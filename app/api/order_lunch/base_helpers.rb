module OrderLunch
  module BaseHelpers
    extend ActiveSupport::Concern
    included do
      format :json
      #formatter :json, Grape::Formatter::ActiveModelSerializers
      formatter :json, Grape::Formatter::Json

      content_type :jsonapi, 'application/vnd.api+json'
      format :jsonapi
      #formatter :jsonapi, Grape::Formatter::ActiveModelSerializers
      formatter :jsonapi, Grape::Formatter::Json


      helpers RenderHelpers
    end
  end
end
