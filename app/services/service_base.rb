class ServiceBase
  class << self
    def call(options = {})
      options = options.with_indifferent_access

      service_obj = new(options)
      if service_obj.callable?
        service_obj.send(:before_call)
        call_result = service_obj.call
        service_obj.send(:after_call)
        call_result
      end
    end
  end

  attr_reader :errors

  def callable?
    true
  end

  def success?
    errors.blank?
  end

  private

  def add_errors(errors)
    @errors ||= []
    @errors += Array(errors)
  end

  def before_call; end

  def after_call; end
end
