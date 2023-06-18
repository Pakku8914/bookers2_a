class GroupMailsController < ApplicationController
  before_action :correct_owner
  def new
    @new_group_mail = GroupMail.new
    @group = Group.find(params[:group_id])
  end

  def create
    @new_group_mail = GroupMail.new(str_params)
    @new_group_mail.group_id = params[:group_id]
    @new_group_mail.save
    @group = Group.find(params[:group_id])
    @owner = @group.owner
    @group.users.each do |user|
      GroupMailer.with(title: @new_group_mail.title, content: @new_group_mail.content,
                       owner_email: @owner.email, owner_name: @owner.name,
                       user_email: user.email).send_mail.deliver_later
    end
    render :complete_mailed
  end

  private
  def correct_owner
    group = Group.find(params[:group_id])
    unless group.owner_id == current_user.id
      redirect_to user_groups_path(current_user.id)
    end
  end

  def str_params
    params.require(:group_mail).permit(:title, :content)
  end
end
