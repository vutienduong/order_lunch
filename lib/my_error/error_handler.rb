module MyError
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        # rescue_from ::StandardError do |e|
        #   custom_respond(:standard_error, 500, e.to_s)
        # end

        rescue_from ::ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404, e.to_s)
        end

        rescue_from MyError::CustomError do |e|
          custom_respond(e.error, e.status, e.message.to_s)
        end
      end
    end

    private

    def respond(_error, _status, _message)
      render file: Rails.root.join('public', _status.to_s), formats: [:html], status: status, layout: false
    end

    def custom_respond(_error, _status, _message)
      @error = _error
      @status = _status
      @message = _message
      render file: Rails.root.join('app/views/errors', 'custom_error'), formats: [:html], status: _status, layout: true
    end
  end
end
