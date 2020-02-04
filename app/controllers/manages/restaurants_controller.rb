# frozen_string_literal: true
include Pagy::Backend

class Manages::RestaurantsController < ManagementsController
  def index
    @pagy, @restaurants = pagy(Restaurant.order("created_at DESC"))
  end

  def new
  end
end
