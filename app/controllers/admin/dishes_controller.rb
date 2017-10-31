class Admin::DishesController < AdminsController
  def new
    @dish = Dish.new(restaurant_id: params[:id])
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.image_url = ''
    if @dish.save
      # upload_image_after_create_dish(params[:dish], @dish)
      redirect_to restaurant_path(@dish.restaurant_id)
    else
      @error = {code: '00x', msg: @dish.errors.messages}
      render 'layouts/error'
    end
  end

  def index
    @dishes = Dish.all
  end

  def show
    @dish = Dish.find(params[:id])
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def destroy
    @dish = Dish.find(params[:id])
    @dish.destroy
    redirect_to restaurants_path
  end

  def update
    @dish = Dish.find(params[:id])
    if @dish.update(dish_params)
      # upload_image_after_create_dish(params[:dish], @dish)
      redirect_to @dish
    else
      @error = {code: '00x', msg: @dish.errors.messages}
      render 'layouts/error'
    end
  end


  private
  def dish_params
    unless params[:dish][:image_url].blank?
      params[:dish][:image] = params[:dish][:image_url].tempfile.read
    end

    params.require(:dish).permit(:name, :price, :description, :restaurant_id, :image)
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