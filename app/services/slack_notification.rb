module SlackNotification
  WEBHOOK_URL = 'https://hooks.slack.com/services/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'.freeze
  ORDER_LUNCH_LINK = 'https://sleepy-escarpment-91996.herokuapp.com/'
  CHANNEL_NAME = "#test-order-lunch"

  def get_notifier
    Slack::Notifier.new WEBHOOK_URL, channel: "#test-order-lunch", username: "Order-Lunch-Admin"
  end

  def send_notify_request_order
    ordered_users = Order.where('DATE(date)=?', Date.today).map(&:user)
    unordered_users = User.all - ordered_users
    slack_names = unordered_users.map(&:slack_name)
    slack_names.compact!
    slack_names.map! {|name| '@' + name}
    slack_names.push CHANNEL_NAME
    # message = "Go to [here](#{ol_link}) to order lunch"
    success_list = []
    fail_list = []
    slack_names.each do |channel_name|
      begin
        get_notifier.ping text: "Please go [here](#{ORDER_LUNCH_LINK}) to order lunch for today. Thank you.", channel: channel_name
        success_list.push channel_name
      rescue => e
        fail_list.push channel_name
      end
    end
    {success: success_list, fail: fail_list}
  end
end