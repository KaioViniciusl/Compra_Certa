class GroupsController < ApplicationController
  before_action :set_group, only: [:send_invite, :accept_invite]

  def index
    @groups = Group.where(user_id: current_user.id)
  end

  def all
    @groups = Group.all
    render :all
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      @group.user_groups.find_or_create_by(user: current_user, user_mail: current_user.email, invite_accepted: true)
      handle_invitations(params[:invite_emails].to_s.split(",").map(&:strip))
      redirect_to group_path(@group), notice: "Grupo criado com sucesso e convites enviados."
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
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
    @group = Group.find(params[:id])
    authorize @group

    @group.destroy
    redirect_to groups_path, notice: "Grupo: #{@group.name_group} foi deletado com sucesso."
  rescue Pundit::NotAuthorizedError
    flash[:alert] = "Você não tem permissão para deletar este grupo."
    redirect_to groups_path
  end

  def send_invite
    user = User.find_by(email: params[:email])

    if user
      if UserGroup.find_by(user: user, group: @group)
        render json: { message: "Usuário já está no grupo." }, status: :unprocessable_entity
      else
        UserGroup.create(user: user, group: @group, invite: true)
        UserMailer.invite_email(@group.id, params[:email], nil, user).deliver_now
        render json: { message: "Convite enviado com sucesso." }
      end
    else
      UserGroup.create(group: @group, invite: true, invite_token: invite_token)
      UserMailer.invite_email(@group.id, params[:email], invite_token).deliver_now
      render json: { message: "Convite enviado com sucesso. O usuário deve se registrar para se juntar ao grupo." }
    end
  end

  def accept_invite
    if current_user
      user_group = UserGroup.find_by(user: current_user, group: @group)

      if user_group && !user_group.invite_accepted
        user_group.update(invite_accepted: true)
        flash[:notice] = "Você agora faz parte do grupo #{@group.name_group}!"
        redirect_to group_path(@group) and return
      else
        flash[:alert] = "Convite inválido ou já aceito."
      end
    else
      flash[:alert] = "Você precisa estar logado para aceitar o convite."
    end
    redirect_to group_path(@group)
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
end
