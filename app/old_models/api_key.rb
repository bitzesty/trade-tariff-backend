class ApiKey

  # include Mongoid::Document
  # include Mongoid::Timestamps

  # field :access_token, type: String
  # field :app_id, type: String

  # before_create :generate_access_token

  # private

  # def generate_access_token
  #   begin
  #     self.access_token = SecureRandom.hex
  #   end while ApiKey.where(access_token: access_token).exists?
  # end

end
