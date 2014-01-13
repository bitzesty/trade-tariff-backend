class Rollback
  include ActiveModel::Model

  attr_accessor :date, :redownload

  validates :date, presence: true
  validate :must_have_correct_date

  private

  def must_have_correct_date
    Date.parse(date)

    rescue ArgumentError
      errors.add(:date, 'Incorrect date provided')
  end
end
