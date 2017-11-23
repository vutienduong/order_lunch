class Admin::DishesController < Admin::AdminsController
  def new
    raise MyError::NonExistRecordError unless Restaurant.find_by(id: params.permit(:id)[:id])
    @dish = Dish.new(restaurant_id: params[:id])
    @tags = Tag.all
  end

  def create
    @dish = Dish.new(dish_params)
    raise MyError::CreateFailError.new @dish.errors.messages unless @dish.save
    redirect_to restaurant_path(@dish.restaurant_id)
  end

  def index
    @dishes = Dish.all
  end

  def show
    @dish = Dish.find_by(id: params.permit(:id)[:id])
    raise MyError::NonExistRecordError.new 'Dish is not exist' unless @dish
  end

  def edit
    show
  end

  def destroy
    @dish = Dish.find(params[:id])
    @dish.destroy
    redirect_to restaurants_path
  end

  def update
    @dish = Dish.find(params[:id])
    raise MyError::CreateFailError.new @dish.errors.messages unless @dish.update(dish_params)
    # upload_image_after_create_dish(params[:dish], @dish)
    redirect_to @dish
  end


  private
  def dish_params
    # unless params[:dish][:image_url].blank?
    #   params[:dish][:image] = params[:dish][:image_url].tempfile.read
    # end

    params.require(:dish).permit(:name, :price, :description, :restaurant_id, :image_logo)
  end

  def upload_image_after_create_dish(params_dish, dish)
    require Rails.root.join('app/services/upload_image')
    uploaded_io = params_dish[:image_url]
    unless uploaded_io.blank?
      file_name = Pathname('').join('dishes', "#{params_dish[:restaurant_id]}_#{dish.id}_#{uploaded_io.original_filename}")
      OLUploadImage.upload(file_name, uploaded_io)
      @dish.update_attributes(image_url: file_name)
    end
  end
end