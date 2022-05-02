#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator ReplaceZeroWidthSpaces
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Alcalde'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name dates].freeze
    end

    def raw_combo_date
      super.gsub(' del ', ' de ').gsub('Presente', 'Incumbent')
    end

    def empty?
      super || (startDate[0...4].to_i < 1995)
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
