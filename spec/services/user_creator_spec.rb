require 'rails_helper'

RSpec.describe UserCreator do
  let(:user_params) do
    {
      name:  "Name",
      password: "Password",
      email: "email@example.com"
    }
  end

  context 'when params are valid' do
    context 'when there is no referral_code' do
      it 'creates user' do
        expect do
          UserCreator.new(user: user_params).create
        end.to change { User.count }.by(1)
      end

      it "doesn't create any referral" do
        expect do
          UserCreator.new(user: user_params).create
        end.not_to change { Referral.count }
      end

      it "doesn't credit any balance" do
        UserCreator.new(user: user_params).create
        expect(User.last.balance).to eq 0.0
      end

      it "returns a valid user" do
        user = UserCreator.new(user: user_params).create
        expect(user).to be_valid
      end
    end

    context 'when there is a referral_code' do
      context 'and an user exists with this referrer_code' do
        let(:referrer) { User.create(name: "Ref", password: "passwd", email: "eml@ex.com", balance: 5.0) }
        let(:creator) { UserCreator.new(user: user_params, referral_code: referrer.referrer_code) }
        
        it 'creates an user with 10 credits' do
          creator.create
          expect(User.last.balance).to eq 10.0
        end

        it 'creates a referral' do
          creator.create
          created_referral = Referral.last
          expect(created_referral.referring_user).to eq referrer
          expect(created_referral.referred_user).to eq User.last
        end

        context 'and this user had 4 referrals already' do
          before do
            referred1 = User.create!(name: "a", password: "00000a", email: "a@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "b", password: "00000b", email: "b@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "c", password: "00000c", email: "c@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "d", password: "00000d", email: "d@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referrer.save!
          end

          it 'gets 10 in credit' do
            creator.create
            expect(referrer.reload.balance).to eq 15.0
          end
        end

        context 'and this user had 5 referrals already' do
          before do
            referred1 = User.create!(name: "a", password: "00000a", email: "a@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "b", password: "00000b", email: "b@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "c", password: "00000c", email: "c@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "d", password: "00000d", email: "d@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referred1 = User.create!(name: "e", password: "00000e", email: "e@example.org")
            referrer.referrals << Referral.new(referred_user: referred1)
            referrer.save!
          end

          it "doesn't change users balance" do
            expect do
              creator.create
            end.not_to change { referrer.reload.balance }
          end
        end
      end
    end

    context 'and no user exists with this referrer_code' do
      let(:creator) { UserCreator.new(user: user_params, referral_code: "123123") }
      
      it 'creates user' do
        expect do
          UserCreator.new(user: user_params).create
        end.to change { User.count }.by(1)
      end

      it "doesn't create any referral" do
        expect do
          UserCreator.new(user: user_params).create
        end.not_to change { Referral.count }
      end

      it "doesn't credit any balance" do
        UserCreator.new(user: user_params).create
        expect(User.last.balance).to eq 0.0
      end
    end
  end

  context 'when an user with given email already exists' do
    before do
      User.create!(user_params)
    end
    it "doesn't create the user" do
      expect do
        UserCreator.new(user: user_params).create
      end.not_to change { User.count }
    end

    it "doesn't create a referral" do
      expect do
        UserCreator.new(user: user_params).create
      end.not_to change { Referral.count }  
    end

    it 'returns invalid user' do
      user = UserCreator.new(user: user_params).create
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ["Email has already been taken"]
    end
  end

  context 'when a required field is blank' do
   let(:user_params) do
      {
        password: "Password",
        email: "email@example.com"
      }
    end 

    it "doesn't create the user" do
      expect do
        UserCreator.new(user: user_params).create
      end.not_to change { Referral.count }  
    end

    it 'returns an invalid user' do
      user = UserCreator.new(user: user_params).create
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq ["Name can't be blank"]
    end  
  end
end