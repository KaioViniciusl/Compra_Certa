class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:edit, :update, :destroy, :show]
  before_action :authorize_group, only: [:edit, :update, :destroy, :show]

  def index
    @groups = policy_scope(Group)
  end

  def show
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = current_user.groups.new(group_params)
    authorize @group

    if @group.save
      @group.user_groups.find_or_create_by(user: current_user, user_mail: current_user.email, invite_accepted: true)
      handle_invitations(params[:invite_emails].to_s.split(",").map(&:strip))
      redirect_to group_path(@group), notice: "Grupo criado com sucesso e convites enviados."
    else
      render :new
    end
  end

  def edit
    # @group já é definido por set_group e authorize @group é chamado por before_action
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "Grupo: #{@group.name_group} foi atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    authorize @group
    
    @group.user_groups.destroy_all
    @group.destroy
    redirect_to groups_path, notice: "Grupo: #{@group.name_group} foi deletado com sucesso."
  rescue Pundit::NotAuthorizedError
    flash[:alert] = "Você não tem permissão para deletar este grupo."
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name_group, :observation, :description_group, :photo)
  end

  def set_group
    @group = Group.find(params[:group_id] || params[:id])
  end

  def handle_invitations(invite_emails)
    invite_emails.each do |email|
      user = User.find_by(email: email)
      if user
        create_user_group_for_existing_user(user)
      else
        create_user_group_for_new_email(email)
      end
    end
  end

  def create_user_group_for_existing_user(user)
    user_group = UserGroup.find_by(user_id: user.id, group_id: @group.id, user_mail: user.email)
    return if user_group

    UserGroup.create(user: user, group: @group, invite_accepted: user == current_user, user_mail: user.email)
    UserMailer.invite_email(@group.id, user.email, user).deliver_now if user != current_user
  end

  def create_user_group_for_new_email(email)
    UserGroup.create(group: @group, user_mail: email)
    UserMailer.invite_email(@group.id, email).deliver_now
  end

  def authorize_group
    authorize @group
  end
end
