class ChangeLog
  include Enumerable

  def initialize(changes = [])
    @changes = changes.map { |change_attributes|
      Change.new(change_attributes)
    }
  end

  def each(&block)
    @changes.each(&block)
  end
end
