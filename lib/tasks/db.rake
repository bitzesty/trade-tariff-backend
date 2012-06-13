namespace :db do
  desc "Import XLS data"
  task import: 'environment' do
    load(File.join(Rails.root, 'db', 'import.rb'))
  end

  desc "Clear data"
  task clear: 'environment' do
    [Measure, AdditionalCode, Footnote, LegalAct].each do |r|
      r.delete_all
    end
  end

  desc "Update duties cache"
  task update_duties_cache: 'environment' do
    Mongoid.unit_of_work(disable: :all) do
      BaseCommodity.batch_size(1000).each_with_index do |c, i|
        c.populate_rates
      end
    end
  end

  desc "Index commodities&headings in ElasticSearch"
  task index: 'environment' do
    Commodity.leaves.each do |commodity|
      commodity.tire.update_index
    end

    Heading.all.each do |heading|
      if heading.commodities.empty?
        heading.tire.update_index
      end
    end
  end
end
