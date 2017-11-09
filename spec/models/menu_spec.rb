require 'rails_helper'

RSpec.describe Menu, type: :Model do
  let! (:menu) {FactoryBot.create(:menu)}

  it 'should be not valid without user' do
    menu.user = nil
    expect(menu).to_not be_valid
  end

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
  it {should accept_nested_attributes_for :restaurants}

end