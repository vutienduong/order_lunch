module FeatureHelpers
  def logged_as(user)
    page.set_rack_session('user_credentials' => user.persistence_token)
  end
end