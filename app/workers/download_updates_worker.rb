class DownloadUpdatesWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, dead: false
  sidekiq_retry_in { |count| 5 }

  delegate :save_entry, to: TariffSynchronizer::BaseUpdate
  attr_reader :response, :date, :type, :filename

  sidekiq_retries_exhausted do |msg|
    TariffSynchronizer::BaseUpdate.save_entry(msg["args"][0], :failed, msg["args"][2], msg["args"][3])
  end

  def perform(date, path, filename, type)
    @date = date
    @filename = filename
    @type = type
    @response = connection.get(path)
    raise "Invalid Status" if invalid_status

    if file_path_not_found
      save_invalid_entry_if_date_is_past
    else
      process_response
    end
  end

  private

  def invalid_status
    [200, 404].exclude?(response.status)
  end

  def file_path_not_found
    response.status == 404
  end

  def connection
    @connection ||= Faraday.new(url: TariffSynchronizer.host) do |faraday|
      faraday.adapter  Faraday.default_adapter
      faraday.request :basic_auth, TariffSynchronizer.username, TariffSynchronizer.password
    end
  end

  def process_response
    begin
      response_contents = response.body
      return save_invalid_entry if response_contents.empty?

      if type == :taric
        Ox.parse(response_contents)
      elsif type == :chief
        CSV.parse(response_contents)
      end

      save_pending_entry
      save_response_contents_to_disk

      rescue CSV::MalformedCSVError => exception
        save_entry_with_exception(exception)
      rescue Ox::ParseError => exception
        save_entry_with_exception(exception)
     end
  end

  def save_invalid_entry_if_date_is_past
    return unless Date.parse(date) < Date.current
    save_entry(date, :failed, "#{date}_#{type}", type)
  end

  def save_pending_entry
    save_entry(date, :pending, filename, type, response.body.size)
  end

  def save_invalid_entry
    save_entry(date, :failed, filename, type)
  end

  def save_response_contents_to_disk
    update_path = File.join(TariffSynchronizer.root_path, type.to_s, filename)
    File.open(update_path, 'wb') { |f| f.write(response.body) }
  end

  def save_entry_with_exception(e)
    save_invalid_entry.update(exception_class: "#{e.class}: #{e.message}",
                              exception_backtrace: e.backtrace.try(:join, "\n"))
  end
end
