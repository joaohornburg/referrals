require 'rails_helper'

RSpec.describe User, type: :model do
  it 'validates presence of name' do
    user = User.new(email: "email@example.com", password: "password")
    expect(user).not_to be_valid
  end

  it 'validates presence of email' do
    user = User.new(name: "Name", password: "password")
    expect(user).not_to be_valid
  end

  it 'validates presence of password' do
    user = User.new(name: "Name", email: "email@example.com")
    expect(user).not_to be_valid
  end
  
  it "generates a referral_code for new user" do
    user = User.create(name: "name", email: "email@example.com", password: "passwd")
    expect(user.referral_code).to be
  end
end
