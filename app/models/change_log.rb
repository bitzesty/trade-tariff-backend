class ChangeLog
  attr_reader :changes

  def initialize(changes = [])
    @changes = changes.map { |change_attributes|
      Change.new(change_attributes)
    }
  end
end
