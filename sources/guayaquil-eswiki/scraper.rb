#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

# Decorator to remove all References & zero-width spaces
class RemoveZReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s.gsub(/[\u200B-\u200D\uFEFF]/, '')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveZReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Alcalde'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name dates].freeze
    end

    def raw_end
      super.to_s.gsub('Presente', '').tidy
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
