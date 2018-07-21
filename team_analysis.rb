require 'csv'
require 'pp'
require_relative 'year_group'


INPUT_CSV_FILE = ARGV[0]
analysis_date = ARGV[1] ? Date.parse(ARGV[1]) : Date.today
team_collection = {}
record_count = 0;
member_stats = 0;

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
    year_group = YearGroup.on Date.today, row['dateofbirth']
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


team_collection.sort.to_h.each do |team, stats|
  next unless team =~ /Junior|Academy|U\d/
  print team
  stats.each do |k, v|
    print ", #{k}->#{v}"
  end
  print "\n"
end
