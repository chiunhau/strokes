require 'iconv'
require 'csv'
require 'json'

def stringFilter(str)
	name = str.gsub(/[^\u4E00-\u9fa5]/, '')
	return name
end

def big5ToCns(name)

	big_5_to_cns = JSON.parse(File.read("big_5_to_cns.json"))
	big5_pre = Iconv.conv("Big5", "utf-8", name).bytes.to_a
	big5_length = big5_pre.length / 2
	big5 = Array.new

	for i in 0...big5_length
		first = big5_pre[i * 2].to_s(16).upcase
		second = big5_pre[i * 2 + 1].to_s(16).upcase
		big5.push(first + second)
	end

	cns = Array.new
	for i in 0...big5_length
		cns.push(big_5_to_cns[big5[i]])
	end

	return cns
end

def cnsToStroke(cns_array)
	cns_to_stroke = JSON.parse(File.read("cns_to_stroke.json"))
	stroke = Array.new
	cns_array.each do |cns|
		stroke.push(cns_to_stroke[cns])
	end	

	return stroke
end

def strokeToPlaces(stroke_sum)
	stroke_to_places = JSON.parse(File.read("stroke_to_places.json"))
	
	if stroke_to_places[stroke_sum.to_s]
		return stroke_to_places[stroke_sum.to_s]
	else
		return nil
	end
end

def updatePlaces
  	places = Hash.new

  	CSV.foreach("stroke_to_places.csv") do |row|
  		place_strokes_sum = 0

  		puts row[0]
  		place_stroke_array = cnsToStroke(big5ToCns(row[0]))
  		place_stroke_array.each do |i|
  			place_strokes_sum += i
  		end
  		puts place_strokes_sum
  		place_hash = { "place" => row[0], "county" => row[1], "town" => row[2]}

  		if !places[place_strokes_sum].kind_of?(Array)
  			places[place_strokes_sum] = Array.new
  		end
  		places[place_strokes_sum].push(place_hash)
  	end


  	File.open("stroke_to_places.json", "w") do |file|
  	  file.puts places.to_json
  	end
  end

  updatePlaces()