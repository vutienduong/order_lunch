class CommentsController < ApplicationController
  include MyError
  def index
    @comments = Comment.all
    @comment = Comment.new
  end

  def new
    @comment = Comment.new
  end

  def create
    params[:comment][:author_id] = session[:user_id]
    params[:comment][:date] = Date.today
    @comment = Comment.new comment_params
    raise MyError::CreateFailError unless @comment.save
    redirect_to comments_path
  end

  private
  def comment_params
    params.require(:comment).permit(:title, :content, :author_id, :date)
  end
end
