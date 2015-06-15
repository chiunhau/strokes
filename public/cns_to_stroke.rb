require 'csv'
require 'json'

strokes = {}
CSV.foreach("cns_to_stroke.csv") do |row|
	cns_full = row[0] + "-" + row[1]
  strokes[cns_full] = row[2].to_s.length
end

File.open("cns_to_stroke.json", "w") do |file|
  file.puts strokes.to_json
end