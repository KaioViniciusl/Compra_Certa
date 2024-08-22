class GroupsController < ApplicationController
  def index
  end

  def new
    @group = Group.new(params[:group])
    @group.save
    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:name_group, :observation, :description_group)
  end
end
