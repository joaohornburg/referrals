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
  
  it "generates a referrer_code for new user" do
    user = User.create(name: "name", email: "email@example.com", password: "passwd")
    expect(user.referrer_code).to be
  end

  it "prevents email from being changed" do
    user = User.create(name: "name", email: "email@example.com", password: "passwd")
    user.email = "other@example.com"
    expect(user).not_to be_valid
    expect(user.update(email: "another@example.com")).to be false
  end

  it "prevents referrer_code from being changed" do
    user = User.create(name: "name", email: "email@example.com", password: "passwd")
    user.referrer_code = "123123123"
    expect(user).not_to be_valid
    expect(user.update(referrer_code: "098098098")).to be false
  end
end
