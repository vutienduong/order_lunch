class Admin::DishesController < Admin::AdminsController
  include ApplicationHelper

  def new
    raise MyError::NonExistRecordError unless Restaurant.find_by(id: params.permit(:id)[:id])
    @dish = Dish.new(restaurant_id: params[:id])
    @tags = Tag.all
  end

  def create
    sizes = params[:dish_size]
    sizes.delete_if {|k, v| v.blank?}

    if sizes.blank?
      @dish = Dish.new(dish_params)
      raise MyError::CreateFailError.new @dish.errors.messages unless @dish.save
    else
      all_sizes = {}
      %w[s m l].each do |s_idx|
        all_sizes[s_idx] = sizes[s_idx] if sizes[s_idx]
        sizes.except!(s_idx)
      end
      #sizes.delete_if {|k, v| v.blank?}

      until sizes.blank? do
        temp = sizes.first[0]
        if temp.include? 'cn'
          cv = temp.tr('n', 'v')
          all_sizes[sizes[temp]] = sizes[cv] if sizes[cv]
        elsif temp[0].include? 'cv'
          cv = temp.tr('v', 'n')
          all_sizes[sizes[cv]] = sizes[temp] if sizes[cv]
        else
          cv = ''
        end
        sizes.except! temp
        sizes.except! cv
      end

      parent_dish = nil
      all_sizes&.each do |k, v|
        new_params = dish_params.merge(size: k, price: v)
        @dish = Dish.new(new_params)
        @dish.name = "#{@dish.name} [#{@dish.size}]"
        @dish.parent = parent_dish
        raise MyError::CreateFailError.new @dish.errors.messages unless @dish.save
        parent_dish ||= @dish
      end
    end
    redirect_to restaurant_path(@dish.restaurant_id)
  end

  def index
    @dishes = Dish.all
  end

  def show
    @dish = Dish.find_by(id: params.permit(:id)[:id])
    raise MyError::NonExistRecordError.new 'Dish is not exist' unless @dish
    @tags = Tag.all
  end

  def edit
    show
  end

  def destroy
    @dish = Dish.find(params[:id])
    @dish.destroy
    redirect_to restaurants_path
  end

  def new_tag
    tag_name = tag_params[:tag_name]
    tag = Tag.find_by(name: tag_name)
    if tag.blank?
      tag = Tag.new(name: tag_name)
      msg = tag.save ? {status: STATUS_OK, message: MSG_SUCCESS, tag: {id: tag.id, name: tag_name}} : {status: STATUS_FAIL, msg: "Fail when create new tag with name (#{tag_name})."}
    else
      msg = {status: STATUS_FAIL, msg: "This tag is existed. Please choose an another name."}
    end
    response_to_json msg
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

    params.require(:dish).permit(:name, :price, :description, :restaurant_id, :image_logo, :sizeable, :tag_ids => [])
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

  def tag_params
    params.permit("tag_name")
  end
end