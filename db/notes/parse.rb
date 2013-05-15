#!/usr/bin/env ruby

# Script meant to extract section and chapter footnotes from HTML files
# that come with CHIEF cd.
#
# Usage:
#
# 1. Put into directory containing htm files (e.g. 10_47_note.htm),
# 2. Create 'sections' directory
# 3. Create 'chapters' directory
# 4. Run script: ruby parse.rb
# 5. Copy files from section and chapters directory to trade-tariff-backend/db/notes directory
# 6. Reload notes in the system:
#    bundle exec rake tariff:install:taric:section_notes
#    bundle exec rake tariff:install:taric:chapter_notes

require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'active_support'
require 'active_support/core_ext/object/blank'

Dir['*.htm'].each do |file|
  ndoc = Nokogiri::HTML(File.read(file))
  section, chapter = file.match(/(.*)_(.*)_note.htm/)[1,2]

  chapter_file = Dir.pwd + "/chapters/#{section}_#{chapter}.yaml"
  unless File.exists? chapter_file
    content = ndoc.xpath("(//td[@class='description'])[2]//td[@class='addinforow']").children.map(&:text).map(&:strip).reject(&:blank?).join("\n")
    unless content.strip.empty?
      File.open(chapter_file, 'w') do |out|
        chapter_doc = {
          section: section,
          chapter: chapter,
          content: content
        }
        YAML::dump(chapter_doc, out)
      end
    end
  end

  section_file = Dir.pwd + "/sections/#{section}.yaml"
  unless File.exists? section_file
    content = ndoc.xpath("(//td[@class='description'])[1]//td[@class='addinforow']").children.map(&:text).map(&:strip).reject(&:blank?).join("\n")
    unless content.strip.empty?
      File.open(section_file, 'w') do |out|
        section_doc = {
          section: section,
          content: content
        }
        YAML::dump(section_doc, out)
      end
    end
  end
end
