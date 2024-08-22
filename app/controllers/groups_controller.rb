class GroupsController < ApplicationController
  def index
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
      redirect_to group_path(@group), notice: "Grupo: #{@group.name_group} foi criado com sucesso."
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
    authorize @group  # Verifica se o usuário tem permissão para destruir o grupo

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
end
