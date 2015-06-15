# utf8tobig5

require 'csv'
require 'json'

dictionary = {}

CSV.foreach("big_5_to_cns.csv") do |row|
  dictionary[row[2]] =  row[0] + '-' + row[1]
end

File.open("big_5_to_cns.json", "w") do |file|
  file.puts dictionary.to_json
end