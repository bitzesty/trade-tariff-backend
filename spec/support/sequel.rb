# for FactoryGirl and Sequel compatibility
class Sequel::Model
  def save!
    save(:validate=>false)
  end
end

