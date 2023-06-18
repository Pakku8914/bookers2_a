class GroupUserController < ApplicationController
  def create
    @group_user = GroupUser.new
    @group_user.user_id = current_user.id
    @group_user.group_id = params[:group_id]
    @group_user.save
    redirect_to user_groups_path(current_user.id)
  end

  def destroy
    @group_user = GroupUser.find(params[:id])
    @group_user.destroy
    redirect_to user_groups_path(current_user.id)
  end
end
