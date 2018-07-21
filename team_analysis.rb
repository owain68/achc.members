require 'csv'
require 'pp'
require_relative 'year_group'


INPUT_CSV_FILE = ARGV[0]
analysis_date = ARGV[1] ? Date.parse(ARGV[1]) : Date.today
team_collection = {}
record_count = 0;
member_stats = 0;
TEAM_REGEX = /U(\d+)/

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
      team_collection[team][:age_group] = team.scan(TEAM_REGEX).last.first if team =~ TEAM_REGEX
      team_collection[team][:members] = []
    end
    if team_collection[team][row['gender']]
      team_collection[team][row['gender']] += 1
    else
      team_collection[team][row['gender']] = 1
    end
    year_group = YearGroup.on analysis_date, row['dateofbirth']
    if team_collection[team][year_group]
      team_collection[team][year_group] += 1
    else
      team_collection[team][year_group] = 1
    end
    entry = {firstname: row['FirstName'], lastname: row['Surname'], dob: row['dateofbirth'], year: year_group}
    entry[:age] = YearGroup.age_on(analysis_date, Date.parse(row['dateofbirth'])) if row['dateofbirth']
    team_collection[team][:members] << entry
  end
end

puts "#{record_count} members processed"
puts "#{member_stats} members analysed for teams"
puts "#{record_count - member_stats} members ignored"
puts "#{team_collection.size} teams found"


team_collection.sort.to_h.each do |team, stats|
  next unless team =~ /Junior|Academy|U\d/
  puts
  print team
  stats.each do |k, v|
    next if k == :members
    print ", #{k}->#{v}"
  end
  next unless stats[:age_group]
  print "\n"
  puts "\n Investigate"
  normal_ages = [stats[:age_group].to_i - 5, stats[:age_group].to_i - 6]
  stats[:members].each do |m|
    highlight = normal_ages.include?(m[:age]) ? '' : '<<<<<<<<'
    printf("  %-40s %-12s  %-7s %-2s     %-10s\n", m[:firstname] + ' ' + m[:lastname], m[:dob], m[:year], m[:age], highlight)
  end
end
