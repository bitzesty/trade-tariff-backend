require 'csv'

class GreenPages
  SPLIT_REGEX = /or|OR/

  cattr_accessor :reference_file
  self.reference_file = File.join(Rails.root, 'db', 'green-pages.csv')

  def self.reload
    SearchReference.truncate

    CSV.foreach(reference_file, {col_sep: ";"}) do |line|
      title, reference = line

      if references_multiple_records?(reference)
        reference.split(SPLIT_REGEX).map(&:strip).each do |ref|
          create_record(title, ref)
        end
      else
        create_record(title, reference)
      end
    end
  end

  private

  def self.create_record(title, reference)
    SearchReference.create(title: title, reference: reference)
  end

  def self.references_multiple_records?(reference)
    reference =~ SPLIT_REGEX
  end
end
