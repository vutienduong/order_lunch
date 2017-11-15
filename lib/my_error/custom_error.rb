module MyError
  class CustomError < StandardError
    attr_reader :status, :error, :message

    def initialize(_error=nil, _status=nil, _message=nil)
      @error = _error || 422
      @status = _status || :unprocessable_entity
      @message = _message || 'Something went wrong'
    end
  end
end