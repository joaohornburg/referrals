require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST create' do
    context 'with valid params' do
      let(:valid_params) do
        {
          name: 'John',
          email: 'john@example.com',
          password: '123qwe',
        }
      end
      
      it 'creates user' do
        expect do
          post :create, params: valid_params
        end.to change {User.count}.by(1)
      end

      it 'is successful' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'renders created user as JSON' do
        post :create, params: valid_params
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['name']).to eq valid_params[:name]
        expect(parsed_body['email']).to eq valid_params[:email]
        expect(parsed_body['password']).to eq valid_params[:password]
        expect(parsed_body['id']).to be
        expect(parsed_body['referral_code']).to be
        expect(parsed_body['balance']).to be
        expect(parsed_body['created_at']).to be
        expect(parsed_body['updated_at']).to be
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          name: 'John',
          password: '123qwe',
          referral_code: 'xlkajd0'
        }
      end

      it 'is unprocessable_entity' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
