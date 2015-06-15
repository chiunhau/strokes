class NamesController < ApplicationController

  require 'iconv'
	require 'csv'
	require 'json'

  def index
  end

  def search
  	name = params[:name]
  	stroke_array = cnsToStroke(big5ToCns(name))
  	@characters = Hash.new

  end

  def stringFilter(str)
  	str.gsub(/[^\u4E00-\u9fa5]/, '')
  	return str
  end
  def big5ToCns(str)

		big_5_to_cns = JSON.parse(File.read("big_5_to_cns.json"))

  	name = stringFilter(str)
  	big5_pre = Iconv.conv("Big5", "utf-8", name).bytes.to_a
  	big5_length = big5.length / 2
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
end
