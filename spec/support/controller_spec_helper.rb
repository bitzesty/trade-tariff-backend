module ControllerSpecHelper
  def pagination_pattern
    { pagination:
      {
        page: 1,
        per_page: Fixnum,
        total_count: Fixnum
      }
    }.ignore_extra_keys!
  end

  def login_as_api_user(user = User.new)
    request.env['warden'] = double("Authenticated API User",
      authenticate!: true,
      authenticated?: true,
      user: user
    )
  end
end
