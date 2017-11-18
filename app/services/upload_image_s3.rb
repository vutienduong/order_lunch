require 'aws-sdk'
module UploadImageS3
  def self.test_upload
    s3 = Aws::S3::Resource.new(region: 'us-east-2')
    obj = s3.bucket('order-lunch').object('key')

# string data
    obj.put(body: 'Hello World!')

# IO object
    File.open('test_s3', 'rb') do |file|
      obj.put(body: file)
    end
  end
end