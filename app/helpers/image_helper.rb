module ImageHelper
  def get_image_source(image, object)
    image.nil? ? image_path("default/default_#{object}") :"data:image/jpg;base64,#{Base64.encode64(image)}"
  end

  def get_s3_image_source restaurant
    restaurant.image_logo.url(:square)
  end
end