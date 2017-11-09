require 'rails_helper'

RSpec.describe Order, :type => :model do
  let! (:order) {create(:order)}
  #let (:order2) {create(:order, user: order.user, date: order.date)}
  let(:dish) {create(:dish)}

  it 'has a valid factory' do
    expect(order).to be_valid
  end

  it 'should be invalid without user' do
    order.user = nil
    expect(order).to_not be_valid
  end

  it 'should be invalid without date' do
    order.date = nil
    expect(order).to_not be_valid
  end

  it 'should be not valid with two orders for same user in a day' do
    expect(FactoryBot.build(:order, user: order.user, date: order.date)).to_not be_valid
  end

  it 'can be added a valid dish' do
    order.dishes.push(dish)
    expect(order).to be_valid
  end

  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:date)}
  #TODO: it {should validate_uniqueness_of(:user).scoped_to(:date)}
  it {should have_many :dishes}
end
