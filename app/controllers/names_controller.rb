class NamesController < ApplicationController

  require 'iconv'
	require 'csv'
	require 'json'

  def index
  end

  def search
  	str = params[:str]
  	name = stringFilter(str)
  	stroke_array = cnsToStroke(big5ToCns(name))
  	
  	@characters = Array.new
  	@stroke_sum = 0
  	num = stroke_array.length
  	for i in 0...num
  		character = { 'chinese' => name[i], 'stroke' => stroke_array[i]}
  		@characters.push(character)
  		@stroke_sum += stroke_array[i]
  	end
  end

  def stringFilter(str)
  	name = str.gsub(/[^\u4E00-\u9fa5]/, '')
  	return name
  end

  def big5ToCns(name)

		big_5_to_cns = JSON.parse(File.read("#{Rails.root}/public/big_5_to_cns.json"))
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
  	cns_to_stroke = JSON.parse(File.read("#{Rails.root}/public/cns_to_stroke.json"))
  	stroke = Array.new
  	cns_array.each do |cns|
  		stroke.push(cns_to_stroke[cns])
  	end	

  	return stroke
  end
end
