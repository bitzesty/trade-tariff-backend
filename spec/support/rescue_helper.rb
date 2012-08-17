module RescueHelper
  def rescuing
    begin
      yield
    rescue Exception
    end
  end
end
