module ImageHelper
  def get_image_source(image, object)
    image.nil? ? image_path("default/default_#{object}") :"data:image/jpg;base64,#{Base64.encode64(image)}"
  end

  def get_s3_image_source restaurant, image_size = 'square'
    restaurant.blank? ? '' : restaurant.image_logo.url(image_size.to_sym)
  end
end