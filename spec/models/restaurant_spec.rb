require 'rails_helper'

RSpec.describe Restaurant, :type => :model do
  let (:restaurant) {create(:restaurant)}
  let(:dish) {create(:dish)}

  it 'has a valid factory' do
    expect(restaurant).to be_valid
  end

  it 'should be invalid without name' do
    restaurant.name = nil
    expect(restaurant).to_not be_valid
  end

  it 'should be valid without address' do
    restaurant.address = nil
    expect(restaurant).to be_valid
  end

  it 'should be valid without phone' do
    restaurant.phone = nil
    expect(restaurant).to be_valid
  end

  it 'should be not valid with name which existed before' do
    expect(FactoryBot.build(:restaurant, name: restaurant.name)).to_not be_valid
  end

  it 'can be added a valid dish' do
    restaurant.dishes.push(dish)
    expect(restaurant).to be_valid
  end

  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of :name}
  it {should have_many :dishes}
  it {should have_many :menus}
end
