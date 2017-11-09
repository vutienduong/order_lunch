require 'rails_helper'

RSpec.describe MenuRestaurant, type: :model do
  it { should belong_to :menu }
  it { should belong_to :restaurant }
end