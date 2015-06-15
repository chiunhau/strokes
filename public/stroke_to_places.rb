require 'iconv'
require 'csv'
require 'json'

def search_strokes(str)
	big5 = Iconv.conv("Big5", "utf-8", str).bytes.to_a
	num = big5.length / 2
	big5_done = Array.new

	for i in 0...num
		first = big5[i * 2].to_s(16).upcase
		second = big5[i * 2 + 1].to_s(16).upcase
		big5_done.push(first + second)
	end

	dictionary = JSON.parse(File.read("dictionary.json"))
	stroke = JSON.parse(File.read("strokes.json"))
	cns = Array.new
	for i in 0...big5_done.length
		cns.push(dictionary[big5_done[i]]["page"] + "-" + dictionary[big5_done[i]]["cns"])
	end

	sum = 0

	for single_cns in cns
		sum += stroke[single_cns]
	end

	return sum
end


places = {}
CSV.foreach("places.csv") do |row|
	place_strokes = search_strokes(row[0]).to_s
	place_hash = { "place" => row[0], "county" => row[1], "town" => row[2]}
	if places[place_strokes].kind_of?(Array)
		places[place_strokes].push(place_hash)
	else
		places[place_strokes] = Array.new
		places[place_strokes].push(place_hash)
	end
end


File.open("places.json", "w") do |file|
  file.puts places.to_json
end