require 'spec_helper'

module TestSessionsHelper
  def rack_session_login user
    page.set_rack_session(user_id: user.id)
    page.set_rack_session(is_admin: user.admin)
  end
end