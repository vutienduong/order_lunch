module OLUploadImage
  def self.upload(file_name, uploaded_io)
    byebug
    File.open(Rails.root.join('app', 'assets', 'images', file_name), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
end