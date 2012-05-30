require 'open-uri'
require 'json'

namespace :doc do
  desc "Collect live API responses for docs"
  task api: 'environment' do
    File.open("#{Rails.root}/app/views/home/docs/_sections.html.erb", "w") do |f|
      f << JSON.pretty_generate(JSON.parse(open("http://localhost:3016/sections").read))
    end
    File.open("#{Rails.root}/app/views/home/docs/_sections_1.html.erb", "w") do |f|
      f << JSON.pretty_generate(JSON.parse(open("http://localhost:3016/sections").read))
    end
    File.open("#{Rails.root}/app/views/home/docs/_chapter.html.erb", "w") do |f|
      f << JSON.pretty_generate(JSON.parse(open("http://localhost:3016/chapters/01").read))
    end
    File.open("#{Rails.root}/app/views/home/docs/_heading.html.erb", "w") do |f|
      f << JSON.pretty_generate(JSON.parse(open("http://localhost:3016/headings/0101").read))
    end
    File.open("#{Rails.root}/app/views/home/docs/_commodity.html.erb", "w") do |f|
      f << JSON.pretty_generate(JSON.parse(open("http://localhost:3016/commodities/0101300000").read))
    end
  end
end
