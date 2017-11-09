require 'rails_helper'

RSpec.describe User, :type => :model do
  let! (:user) {create(:user)}

  it 'has a valid factory' do
    expect(user).to be_valid
  end


  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is not valid without a username' do
    user.username = nil
    expect(user).to_not be_valid
  end

  it 'is not valid without a email' do
    user.email = nil
    expect(user).to_not be_valid
  end

  it 'is not valid without a password' do
    user.password = nil
    expect(user).to_not be_valid
  end

  it 'is not valid with a username longer than 30 characters' do
    user.username = Faker::Name.name * 30
    expect(user).to_not be_valid
  end

  it 'should be not valid with non-unique email' do
    expect(FactoryBot.build(:user, email: user.email)).to_not be_valid
  end

  it {should validate_presence_of(:username)}
  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}

end
