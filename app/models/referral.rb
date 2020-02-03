class Referral < ApplicationRecord
  belongs_to :referred_user, class_name: User.to_s
  belongs_to :referring_user, class_name: User.to_s
end
