class Types::AvailabilityType < ActiveRecord::Type::String

  def serialize value
    return value if value == ""
     a = []
     value.each do |k, v|
       a << "#{v[:from]}-#{v[:to]}"
     end
     a.join(",")
  end

  def deserialize value
    return value if value == ""
     a = {}
     ranges =  value.split(",")
     days.each do |day|
       ranges
       range = ranges.shift.split("-")
       a[day] = {
         from: range[0],
         to: range[1]
       }
     end
    a
  end

  def cast value
    value
  end

  private

  def days
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  end
end
