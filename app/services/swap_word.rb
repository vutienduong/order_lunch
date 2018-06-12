class SwapWords < Slack::Notifier::PayloadMiddleware::Base
  middleware_name :swap_words # this is the key we use when setting
  # the middleware stack for a notifier

  options pairs: ["hipchat" => "slack"] # the options takes a hash that will
  # serve as the default if not given any
  # when initialized

  def call payload={}
    return payload unless payload[:text] # noope if there is no message to work on

    # not efficient, but it's an example :)
    options[:pairs].each do |from, to|
      payload[:text] = payload[:text].gsub from, to
    end

    payload # always return the payload from your middleware
  end
end
