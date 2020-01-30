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

      it 'returns unprocessable_entity' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET show' do
    context 'when user exists' do
      let(:user) { User.create(name: 'John', email: 'john@example.com', password: '123qwe',) }

      it 'renders user as JSON' do
        get :show, params: { id: user.id }
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['name']).to eq user.name
        expect(parsed_body['email']).to eq user.email
        expect(parsed_body['password']).to eq user.password
        expect(parsed_body['id']).to eq user.id
        expect(parsed_body['referral_code']).to eq user.referral_code
        expect(parsed_body['balance']).to eq user.balance.to_s
        expect(parsed_body['created_at']).to eq user.created_at.as_json
        expect(parsed_body['updated_at']).to eq user.updated_at.as_json
      end
    end

    context "when user doesn't exist" do
      it 'returns not_found' do
        get :show, params: { id: 8976 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { User.create(name: 'John', email: 'john@example.com', password: '123qwe',) }
    
    it 'deletes user' do
      expect do
          delete :destroy, params: { id: user.id }
        end.to change {User.count}.by(-1)
    end

    it 'returns ok' do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PUT update' do
    let(:user) { User.create(name: 'John', email: 'john@example.com', password: '123qwe',) }

    context 'with valid params' do
      let(:valid_params) do
        {
            name: 'John Edwards',
            password: '123qwe123qwe',
        }
      end

      it 'is successful' do
        put :update, params: valid_params.merge({ id: user.id })
        expect(response).to have_http_status(:ok)
      end

      it 'updates user' do
        expect do
          put :update, params: valid_params.merge({ id: user.id })
        end.to change { User.first.name }.from(user.name).to(valid_params[:name])
      end
    end

    context "when user doesn't exist" do
      it 'returns not_found' do
        put :update, params: { id: 8976 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
