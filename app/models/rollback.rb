class Rollback
  include ActiveModel::Model

  attr_accessor :date, :redownload

  validates :date, presence: true
end
