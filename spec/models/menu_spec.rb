require 'spec_helper'

RSpec.describe Menu, type: :model do
  let! (:menu) {create(:menu)}

  it 'should be not valid without date' do
    menu.date = nil
    expect(menu).to_not be_valid
  end

  it 'should be valid without restaurant' do
    expect(menu).to be_valid
  end

  it 'should have unique date for each menu' do
    expect(FactoryBot.build(:menu, date: menu.date)).to_not be_valid
  end


  it {should have_many :menu_restaurants}
  it {should have_many :restaurants} # TOOD: via menu_restaurants
  it {should validate_presence_of :date}
  it {should validate_presence_of :restaurants}
  it {should validate_uniqueness_of :date}
  it {should accept_nested_attributes_for :restaurants}
end