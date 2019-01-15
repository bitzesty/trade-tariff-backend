module RescueHelper
  def rescuing
    begin
      yield
    rescue StandardError
    end
  end
end
