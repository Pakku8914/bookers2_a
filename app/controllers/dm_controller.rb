class DmController < ApplicationController
	def index
		@new_message = Dm.new
		@user = User.find(params[:user_id])
		@sent_messages = Dm.where(sender_id: current_user.id, receiver_id: @user.id)
		@received_messages = Dm.where(receiver_id: current_user.id, sender_id: @user.id)
		@all_messages = (@sent_messages + @received_messages).uniq.sort_by(&:created_at)
	  end
	
	  def create
		@new_message = Dm.new(str_params)
		@new_message.sender_id = current_user.id
		@new_message.receiver_id = params[:user_id]
		@new_message.save!
		redirect_to user_dm_index_path(@new_message.receiver_id)
	  end
	
	
	  private
	  def str_params
		params.require(:dm).permit(:message)
	  end
end
