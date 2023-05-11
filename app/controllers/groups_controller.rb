class GroupsController < ApplicationController
    before_action :correct_user?, only: [:edit, :update]

    def new
        @new_group = Group.new
        @new_group.group_users.new
    end

    def index
        @new_group = Group.new
        @groups = Group.all
        @book = Book.new
    end

    def show
        @group = Group.find(params[:id])
        @group_member = @group.users
        @book = Book.new
    end

    def create
        @new_group = Group.new(str_params)
        @new_group.owner_id = current_user.id
        @new_group.save
        @new_group_user = @new_group.group_users.new
        @new_group_user.user_id = current_user.id
        @new_group_user.save
        redirect_to user_groups_path(current_user.id)
    end

    def edit
        @update_group = Group.find(params[:id])
    end

    def update
        @update_group = Group.find(params[:id])
        @update_group.update(str_params)
        redirect_to user_groups_path(current_user)
    end

    private
    def str_params
        params.require(:group).permit(:name, :introduction, :image)
    end

    def correct_user?
        group = Group.find(params[:id])
        unless current_user.id == group.owner_id
            redirect_to user_groups_path(current_user)
        end
    end
end
