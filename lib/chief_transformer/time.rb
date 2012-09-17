class Time
  def self.after(start_time, end_time)
    if end_time.present?
      if start_time.blank? || start_time > end_time
        true
      else
        false
      end
    elsif start_time.blank?
      true
    else
      false
    end
  end
end
