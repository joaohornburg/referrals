require 'rails_helper'

RSpec.describe ReferralsController, type: :controller do
  describe "GET #index" do
    context 'when user exists' do
      let!(:user) { User.create(name: 'User Name', email: 'email@example.com', password: 'password') }
    
      it "returns http success" do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:success)
      end

      context 'when user has referrals' do
        let(:referred_user_1) { User.create(name: 'Referred User 1', email: 'referred1@example.com', password: 'password') }
        let(:referred_user_2) { User.create(name: 'Referred User 2', email: 'referred2@example.com', password: 'password') }

        before do
          user.referrals << Referral.new(referred_user: referred_user_1)
          user.referrals << Referral.new(referred_user: referred_user_2)
        end

        it 'returns their name, email and created_at as json' do
          response = get :index, params: { user_id: user.id }
          parsed_body = JSON.parse(response.body)
          expected = [
            referred_user_1.public_attributes.as_json,
            referred_user_2.public_attributes.as_json
          ]
          expect(parsed_body).to eq expected
        end
        
      end

      context 'when user has no referral' do
        it 'returns an empty array' do
          response = get :index, params: { user_id: user.id }
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq []
        end
      end      
    end

    context 'when user doesnt exist' do
      it 'returns not_found' do
        response = get :index, params: { user_id: 123 }
        expect(response).to have_http_status :not_found
      end
    end
  end
end
