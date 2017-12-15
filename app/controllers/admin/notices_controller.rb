class Admin::NoticesController < Admin::AdminsController
  include MyError

  def show
    @notice = Notice.last
  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])
    @notice.update(notice_params)
    @notice.author_id = current_user.id
    raise MyError.UpdateFailError unless @notice.save
    redirect_to notice_path(@notice)
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)
    @notice.author_id = current_user.id
    raise MyError.CreateFailError unless @notice.save
    redirect_to notice_path(@notice)
  end

  private
  def notice_params
    params.require(:notice).permit(:content)
  end
end
