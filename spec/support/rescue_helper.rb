module RescueHelper
  def rescuing
    begin
      yield
    rescue
    end
  end
end
