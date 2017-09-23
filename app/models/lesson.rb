class Lesson < ApplicationRecord
  attr_accessor :starts_at_time, :starts_at_date, :ends_at_time, :ends_at_date

  belongs_to :sender, class_name: "User",  foreign_key: 'sender_id'
  belongs_to :receiver, class_name: "User", foreign_key: 'receiver_id'
  belongs_to :subject

  before_create :serialize_time

  private

  def serialize_time
    self.starts_at = DateTime.parse("#{starts_at_date} #{starts_at_time}")
    self.ends_at = DateTime.parse("#{ends_at_date} #{ends_at_time}")
  end
end
