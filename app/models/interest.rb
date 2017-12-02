class Interest < ApplicationRecord
  include PublicActivity::Common

  belongs_to :user
  belongs_to :subject
end
