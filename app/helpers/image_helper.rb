module ImageHelper
  def check_image_not_nil?(image, object)
    image.nil? ? image_path("default/default_#{object}") :"data:image/jpg;base64,#{Base64.encode64(image)}"
  end
end