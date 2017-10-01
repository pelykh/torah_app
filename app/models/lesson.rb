class Lesson < ApplicationRecord
  attr_accessor :starts_at_time, :starts_at_date, :ends_at_time, :ends_at_date

  belongs_to :sender, class_name: "User",  foreign_key: 'sender_id'
  belongs_to :receiver, class_name: "User", foreign_key: 'receiver_id'
  belongs_to :subject

  validate :check_if_users_have_lessons_at_time_range
  validate :check_if_time_range_is_valid
  validate :check_if_users_are_available

  before_validation :serialize_time, on: :create

  private

  def check_if_users_have_lessons_at_time_range
    sender_recurring_lessons = sender.lessons.where(recurring: true).map do |l|
      l.starts_at = Time.zone.parse("#{weekday(l.starts_at)} #{l.starts_at.to_s(:time)}")
      l.ends_at = Time.zone.parse("#{weekday(l.ends_at)}, #{l.ends_at.to_s(:time)}")
      l
    end

    sender_lessons = sender.lessons.where("((starts_at >= ? AND starts_at < ?) OR
      (ends_at > ? AND ends_at <= ?)) AND confirmed_at IS NOT NULL", starts_at, ends_at, starts_at, ends_at)
    errors.add(:starts_at, "#{sender.name} is busy at that time") if sender_lessons.any? || sender_recurring_lessons.select do |l|
     (starts_at >= l["starts_at"] && starts_at < l["ends_at"]) || (ends_at > l["starts_at"] && ends_at <= l["ends_at"])
   end.any?

   receiver_recurring_lessons = receiver.lessons.where(recurring: true).map do |l|
     l.starts_at = Time.zone.parse("#{weekday(l.starts_at)} #{l.starts_at.to_s(:time)}")
     l.ends_at = Time.zone.parse("#{weekday(l.ends_at)}, #{l.ends_at.to_s(:time)}")
     l
   end

    receiver_lessons = receiver.lessons.where("((starts_at >= ? AND starts_at < ?) OR
      (ends_at > ? AND ends_at <= ?) OR (starts_at >= ? AND ends_at <= ?)) AND confirmed_at IS NOT NULL", starts_at, ends_at, starts_at, ends_at, starts_at, ends_at)
    errors.add(:starts_at, "#{receiver.name} is busy at that time") if receiver_lessons.any? || receiver_recurring_lessons.select do |l|
     (starts_at >= l["starts_at"] && starts_at < l["ends_at"]) || (ends_at > l["starts_at"] && ends_at <= l["ends_at"])
   end.any?
  end

  def weekday date
    Date::DAYNAMES[date.wday].downcase
  end

  def check_if_users_are_available
    lesson_day = weekday(starts_at).to_sym
    starts_at_time = starts_at.to_s(:time).to_time

    receiver_available_from = Time.zone.parse(receiver.availability[lesson_day][:from]).to_time
    receiver_available_to = Time.zone.parse(receiver.availability[lesson_day][:to]).to_time
    errors.add(:starts_at,
      "#{receiver.name} is unavailable at that time") unless starts_at_time.between?(receiver_available_from, receiver_available_to)

    sender_available_from = Time.zone.parse(sender.availability[lesson_day][:from]).to_time
    sender_available_to = Time.zone.parse(sender.availability[lesson_day][:to]).to_time
    errors.add(:starts_at,
      "#{sender.name} is unavailable at that time") unless starts_at_time.between?(sender_available_from, sender_available_to)
  end

  def check_if_time_range_is_valid
    if starts_at >= ends_at
      errors.add(:starts_at, :invalid)
      errors.add(:ends_at, :invalid)
    end

    unless starts_at > Time.current || recurring
      errors.add(:starts_at, "You can`t set up lesson on  past days")
    end
  end

  def serialize_time
    self.starts_at = Time.zone.parse("#{starts_at_date} #{starts_at_time}")
    self.ends_at = Time.zone.parse("#{ends_at_date} #{ends_at_time}")
  end

  def self.time_for current_user, user
    self.select("starts_at, ends_at, recurring").where("(sender_id = ? OR receiver_id = ? OR sender_id = ? OR receiver_id = ?) AND confirmed_at IS NOT NULL",
      current_user.id ,current_user.id, user.id, user.id).to_json
  end
end
