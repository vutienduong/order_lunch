class Error
  attr_accessor :code, :message
  def initialize(code, msg)
    @code = code
    @message = msg
  end
end
