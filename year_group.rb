require 'date'

class YearGroup

  def self.on(at, dob)
    return 'no dob' unless dob
    birthday = Date.parse(dob)
    last_day_of_school_year = at > Date.new(at.year, 8, 31) ? Date.new(at.year + 1, 8, 31) : Date.new(at.year, 8, 31)
    age = self.age_on(last_day_of_school_year, birthday)
    "Y#{age - 5}"
  end

  def self.age_on(at, dob)
    years = at.year - dob.year
    years -= 1 if dob.month > at.month || (dob.month >= at.month && dob.day > at.day)
    years
  end
end