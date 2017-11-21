class Admin::CommentsController < Admin::AdminsController
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_path
  end
end