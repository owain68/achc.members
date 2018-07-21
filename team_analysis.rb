require 'csv'
require 'pp'

def year_group_on (at, dob)
  return 'no dob' unless dob
  birthday = Date.parse(dob)
  last_day_of_school_year = at > Date.new(at.year, 8, 31) ? Date.new(at.year + 1, 8, 31) : Date.new(at.year, 8, 31)
  "Y#{last_day_of_school_year.year - birthday.year - 5}"
end

INPUT_CSV_FILE = ARGV[0]
team_collection = {}
record_count = 0;
member_stats = 0;

# PlayerID,FirstName,Surname,Login,homePhone,workPhone,admin,forumadmin,reporter,selector,sitedesign,pageeditor,memberadmin,teamadmin,mobile,email,Column1,nickname,address,crb,dateofbirth,teamdescription,playing,gender,Subs paid?,matches,registered,pastmember,Umpire,UmpiringQualification,CoachingQualification,Junior(not18on1stSept),Veterans,Vintage,PlayTwice,Restrictions,LifeMember,GXJunior,Subs,Playing roles
CSV.foreach(INPUT_CSV_FILE, headers: true) do |row|
  record_count += 1
  next if row['pastmember'] == 'TRUE' # skip if no longer a member
  next unless row['teamdescription'] # skip if no team allocations for member
  member_stats += 1
  row['teamdescription'].split(', ').each do |team|
    if team_collection[team] then
      team_collection[team][:count] += 1
    else
      team_collection[team] = {}
      team_collection[team][:count] = 1
    end
    if team_collection[team][row['gender']]
      team_collection[team][row['gender']] += 1
    else
      team_collection[team][row['gender']] = 1
    end
    year_group = year_group_on Date.today, row['dateofbirth']
    if team_collection[team][year_group]
      team_collection[team][year_group] += 1
    else
      team_collection[team][year_group] = 1
    end
  end
end

puts "#{record_count} members processed"
puts "#{member_stats} members analysed for teams"
puts "#{record_count - member_stats} members ignored"
puts "#{team_collection.size} teams found"


pp team_collection.sort.to_h
