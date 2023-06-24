class TagsController < ApplicationController
  def index
    @books = Book.where(tag: params[:tag])
  end
end
