require "csv"

class ImportCasNumbers
  def self.reload
    CasNumber.truncate

    files = ["cas-numbers-1.csv", "cas-numbers-2.csv"]
    files.each do |file|
      path = File.join(Rails.root, "db", file)

      CSV.foreach(path, {col_sep: ";"}) do |line|
        reference = line[0].to_s.gsub(/[^0-9]/, "")
        titles = line[1..-1]

        titles.each { |t| create_record(t, reference) }
      end
    end
  end

  private

  def self.create_record(title, reference)
    CasNumber.create(title: title.downcase, reference: reference) if title.present? && reference.present?
  end
end
