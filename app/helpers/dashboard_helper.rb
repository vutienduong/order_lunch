module DashboardHelper
  def active_state_for(item)
    case item
      when :order_lunch
        'active' if controller_name == 'dashboards' && action_name == 'index'
    end
  end
end
