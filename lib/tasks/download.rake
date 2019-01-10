namespace :tariff do
  namespace :download do
    desc 'Download all Taric files from production AWS S3'
    task taric: %w[environment] do
      s3 = Aws::S3::Resource.new
      files = s3.bucket('tariff-production')
                .objects(prefix: 'data/taric/')
                .collect(&:key)
                .delete_if { |o| o.to_s !~ /\.xml$/ }
      s3 = Aws::S3::Client.new
      files.each do |key|
        File.open(key, 'wb') do |file|
          s3.get_object(bucket: 'tariff-production', key: key) do |chunk|
            file.write(chunk)
          end
        end
      end
    end

    desc 'Download all CHIEF files from production AWS S3'
    task chief: %w[environment] do
      s3 = Aws::S3::Resource.new
      files = s3.bucket('tariff-production')
                .objects(prefix: 'data/chief/')
                .collect(&:key)
                .delete_if { |o| o.to_s !~ /\.txt$/ }
      s3 = Aws::S3::Client.new
      files.each do |key|
        File.open(key, 'wb') do |file|
          s3.get_object(bucket: 'tariff-production', key: key) do |chunk|
            file.write(chunk)
          end
        end
      end
    end

    desc 'Download all measures log files from development AWS S3'
    task measures_log: %w[environment] do
      s3 = Aws::S3::Resource.new
      files = s3.bucket('tariff-dev')
                .objects(prefix: 'data/measures/')
                .collect(&:key)
                .delete_if { |o| o.to_s !~ /\.txt$/ }
      s3 = Aws::S3::Client.new
      files.each do |key|
        File.open(key, 'wb') do |file|
          s3.get_object(bucket: 'tariff-dev', key: key) do |chunk|
            file.write(chunk)
          end
        end
      end
    end
  end
end
