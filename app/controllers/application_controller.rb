#require File.join(Rails.root, 'lib/error/error_handler.rb')

#Dir[Rails.root.join('lib/error/*.rb')].each {|file| require file }

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include MyError::ErrorHandler

  # def current_user
  #   super || User.new
  # end
end
