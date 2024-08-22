class GroupsController < ApplicationController
  def index
  end

  def all
    @groups = Group.all
    render :all
  end

  def new
    @group = Group.new(params[:group])
    @group.save
    redirect_to group_path(@group)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path, status: :see_other
  end

  private

  def group_params
    params.require(:group).permit(:name_group, :observation, :description_group)
  end
end
