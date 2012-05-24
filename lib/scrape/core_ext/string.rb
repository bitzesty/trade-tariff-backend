class String
  def normalize
    self.gsub(/\A[[:space:]]*(.*?)[[:space:]]*\z/) { $1 }
  end
end
