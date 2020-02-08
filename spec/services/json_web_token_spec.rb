require 'rails_helper'

RSpec.describe JsonWebToken do
  describe '.encode' do
    it 'calls JWT and returns the encoded token' do
      expiration = 2.hours.from_now
      payload = { email: 'john@example.com', expiration: expiration }
      expect(JWT).to receive(:encode)
        .with(payload, Rails.application.secrets.secret_key_base.to_s)
        .and_return("token")
      expect(JsonWebToken.encode(payload)).to eq "token"
    end
  end

  describe '.decode' do
    it 'calls JWT and returns the decoded token' do
      jwt_response = [{"email"=>"email@example.com", "expiration"=>1581256629}, {"alg"=>"HS256"}]
      expect(JWT).to receive(:decode)
        .with("token", Rails.application.secrets.secret_key_base.to_s)
        .and_return(jwt_response)
      expected_response = { email: 'email@example.com', expiration: 1581256629 }.with_indifferent_access
      expect(JsonWebToken.decode("token")).to eq expected_response
    end
  end
end