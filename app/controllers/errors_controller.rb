class ErrorsController < ApplicationController
  before_action :require_login
  def not_found
    render file: Rails.root.join('public', '404'), formats: [:html], status: 404, layout: false
  end

  def internal_server_error
    render file: Rails.root.join('public', '500'), formats: [:html], status: 500, layout: false
  end

  def render_custom_error
    render file: Rails.root.join('views/errors/custom_error'), formats: [:html], status: 1000, layout: true
  end
end
