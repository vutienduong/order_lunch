# frozen_string_literal: true

class ManagementsController < ApplicationController
  layout 'management'
  before_action :require_login
  before_action :authorize_administration
end
