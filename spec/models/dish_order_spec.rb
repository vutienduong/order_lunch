require 'rails_helper'

RSpec.describe DishOrder, type: :model do
  it { should belong_to :dish }
  it { should belong_to :order }
end