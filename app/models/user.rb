class User < Sequel::Model
  include GDS::SSO::User

  plugin :serialization

  serialize_attributes :yaml, :permissions

  module Permissions
    SIGNIN = 'signin'
    HMRC_EDITOR = 'HMRC Editor'
    GDS_EDITOR = 'GDS Editor'
  end

  def self.find_for_gds_oauth(auth_hash)
    user_params = user_params_from_auth_hash(auth_hash)

    # update details of existing user
    if user = find(uid: auth_hash["uid"])
      user.update(user_params)
    else # Create a new user.
      create(user_params)
    end
  end

  def self.user_params_from_auth_hash(auth_hash)
    GDS::SSO::User.user_params_from_auth_hash(auth_hash.to_hash)
  end

  def self.find_by_uid(uid)
    find(uid: uid)
  end

  def gds_editor?
    has_permission?(Permissions::GDS_EDITOR)
  end

  def hmrc_editor?
    has_permission?(Permissions::HMRC_EDITOR)
  end

  def remotely_signed_out?
    remotely_signed_out
  end

  def update_attribute(attribute, value)
    update({ attribute => value })
  end
end
