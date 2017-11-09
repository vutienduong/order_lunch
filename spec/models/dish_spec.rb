require 'rails_helper'

#TODO: Refactor this file
RSpec.describe Dish, type: :model do
  let(:restaurant) {Restaurant.new(name: 'New World')}
  subject {described_class.new(name: 'sds', price: 'fds', restaurant: restaurant)}


  it 'is valid with price equal_or_larger_than_1000' do
    subject.price = 1000
    expect(subject).to be_valid
  end

  it 'is not valid with price is not number' do
    expect(subject).to_not be_valid
  end

  it 'is not valid with price is not equal_or_larger_than_1000' do
    subject.price = 999
    expect(subject).to_not be_valid
  end

  it 'is valid with price is string_of_number' do
    subject.price = '1999'
    expect(subject).to be_valid
  end

  describe 'Test Class method and scopes' do
    it 'has unique name' do
      restaurant = create(:restaurant, name: 'rest 1')
      dish1 = create(:dish, name: 'dish1', restaurant: restaurant)
      dish2 = build(:dish, name: 'dish1', restaurant: restaurant)

      puts 'dish1 #{dish1.restaurant.name}'
      puts 'dish2 #{dish2.restaurant.name}'
      expect(dish2).to_not be_valid
    end
  end


  describe 'Associations' do
    it {should belong_to(:restaurant)}
    it {should have_many(:orders)} #TODO: through dish_orders
    it {should have_many(:dish_orders)}
  end

  describe 'Validation' do
    it {should validate_presence_of(:restaurant)}
    #TODO: validates presence of name, uniqueness
    it {should validate_numericality_of(:price)} #TODO: greater than 1000
  end
end