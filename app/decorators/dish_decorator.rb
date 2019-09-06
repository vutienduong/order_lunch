class DishDecorator < Draper::Decorator
  delegate_all

  def detail_as_json
    {
      id: object.id,
      name: object.name,
      price: object.price,
      image: dish_image_url
    }.to_json
  end

  private

  def dish_image_url
    h.get_s3_image_source(object.presence, 'square')
  end
end
