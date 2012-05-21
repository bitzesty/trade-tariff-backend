require 'forgery'
require 'factory_girl'
require File.join(Rails.root, 'spec', 'factories.rb') unless FactoryGirl.factories.registered?(:section)

nomenclature = Nomenclature.find_or_create_by(as_of_date: Date.today)

3.times do
  section = FactoryGirl.create :section, nomenclature: nomenclature

  3.times do
    chapter = FactoryGirl.create(:chapter, section: section, nomenclature: nomenclature)

    3.times do
      heading = FactoryGirl.create(:heading, chapter: chapter, nomenclature: nomenclature)
      3.times do
        commodity = FactoryGirl.create(:commodity, heading: heading, nomenclature: nomenclature)
      end
    end
  end
end
