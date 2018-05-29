module OrderLunch
  module RenderHelpers
    def response_model(model, options = {})
      if model.errors.any?
        render_model_api_error!(model, 400)
      elsif options[:serializer]
        render model, serializer: options[:serializer]
      else
        model
      end
    end
  end
end
