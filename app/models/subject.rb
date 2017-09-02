class Subject < ApplicationRecord
  has_many :interests
  has_many :users, through: :interests
  belongs_to :parent, class_name: 'Subject', optional: true
  has_many :children, class_name: 'Subject', foreign_key: :parent_id
end
