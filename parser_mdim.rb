#!/usr/bin/ruby
# encoding: utf-8
 
module MultiDimDataParser
  class HtmlParser
    def initialize(data_filename)
      @data_filename = data_filename
    end
    #
    def process_ai_note_export
      # define a html parser method
      require 'nokogiri'  # a famous ruby html parser module
      require 'matrix'    # a matrix module for aligning ai-note 
                          # titles and tags together

      fname = @data_filename

      # Get a Nokogiri::HTML:Document for the page we're interested in...
      doc = Nokogiri::HTML(open(fname))

      # note title array
      titles = []

      # Search for nodes by css
      doc.xpath('//body/h1').each do |link|
        row_hash = Hash.new
        row_hash['title'] = link.content
        titles<<row_hash  # store current title into array
      end

      # note tag array
      attrs = []

      # read the tags table into memory
      rows = doc.xpath('//table[@bgcolor="#D4DDE5"]/tr')

      # process each row of the table
      details = rows.collect do |row|
        row_hash = Hash.new
        row_hash['key'] = row.at_xpath('td[1]').content    # get cont from 1st col
        row_hash['values'] = row.at_xpath('td[2]').content  # get cont from 2nd col
        if row_hash['key'] == '标签：' then
          attrs<<row_hash  # store current tag series into array
        end
      end

      # align the titles with attrs in a 2 x N matrix
      # row 1 for titles => note: this data structure can be encapsulated.
      # row 2 for tags
      data_mat = [titles, attrs]
      return data_mat
    end
    #
    def show_data_mat(data_mat)
      # print out the aligned titles and tags
      0.upto(data_mat[0].length - 1).each do |i|
        puts data_mat[0][i], data_mat[1][i] 
        puts "\n========\n"
      end
    end
  end
end

