class Admin::PicturesController < Admin::AdminsController
  def new
    redirect_to new_picture_path
  end

  def create
    redirect_to pictures_path
  end

  def index
    redirect_to pictures_path
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def update
    @picture = Picture.find(params[:id])
    raise MyError::UpdateFailError unless @picture.update picture_params
    redirect_to picture_path @picture.id
  end

  def show
    redirect_to picture_path params[:id]
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    redirect_to pictures_path
  end

  private

  def picture_params
    params.require(:picture).permit(:name, :image)
  end
end