class CommentsController < ApplicationController
  include MyError
  before_action :require_login

  PER_PAGE = 5
  DEFAULT_PAGE = 1

  def index
    per_page = params[:per] || PER_PAGE
    page = params[:page] || DEFAULT_PAGE
    @comments = Comment.all.includes(:author).page(page).per(per_page)
    @comment = Comment.new
  end

  def new
    @comment = Comment.new
  end

  def create
    params[:comment][:author_id] = session[:user_id]
    params[:comment][:date] = Time.zone.today
    @comment = Comment.new comment_params
    raise MyError::CreateFailError unless @comment.save
    redirect_to comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content, :author_id, :date)
  end
end
