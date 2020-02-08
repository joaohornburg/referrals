require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST login' do
    context 'when user exists' do
      let(:email) { 'email@example.com' }
      let(:password) { 'password' }
      let!(:user) { User.create(name: 'Name', email: email, password: password) }

      context 'when password matches' do
        before do
          freeze_time # to avoid intermitencies in expiration time spec
        end

        after do
          travel_back
        end

        it 'is successfull' do
          post :login, params: { email: email, password: password }
          expect(response).to have_http_status(:ok)
        end

        it 'returns token, expiration and email' do
          allow(JsonWebToken).to receive(:encode).with({email: email, user_id: user.id}).and_return("token")
          post :login, params: { email: email, password: password }
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq ({ token: "token", expiration: 24.hours.from_now.as_json, email: email }.stringify_keys)
        end
      end

      context 'when password doesnt match' do
        it 'heads unauthorized' do
          post :login, params: { email: email, password: 'something_else' }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when user doesnt exist' do
      it 'heads unauthorized' do
        post :login, params: { email: 'nonexisting@email.com', password: 'something_else' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
