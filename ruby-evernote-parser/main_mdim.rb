#!/usr/bin/ruby

require 'parser_mdim'
require 'refiner_mdim'

include MultiDimDataRefine
include MultiDimDataParser

def build_entity_arr(data_mat)
  tags_arr = []
  0.upto(data_mat[0].length - 1).each do |i|
    tags_arr = tags_arr + [data_mat[0][i]['title']]
  end
  return tags_arr
end

def build_tags_arr(data_mat)
  tags_arr = []
  0.upto(data_mat[0].length - 1).each do |i|
    tags_arr = tags_arr + [data_mat[1][i]['values'].split(', ')]
  end
  return tags_arr
end

parser = HtmlParser.new(ARGV[0])

data_mat = parser.process_ai_note_export
#parser.show_data_mat(data_mat)
#parser.data_mat_to_entity_arr(data_mat)

refiner = DataRefiner.new

# prepare the data
tags_arr = build_tags_arr(data_mat)

puts "original tags array"
puts "========"
puts tags_arr.length
print tags_arr, "\n"

#titles_arr = build_titles_arr(data_mat)
dim_array = refiner.build_dim_array(tags_arr)
puts "aligned dim array"
puts "========"
print dim_array, "\n"

puts "aligned tags array"
puts "========"
0.upto(tags_arr.length - 1).each do |idx|
  mdim_mat = refiner.apply_dim_array(dim_array, tags_arr[idx])
  print mdim_mat.join(','), "\n"
end
