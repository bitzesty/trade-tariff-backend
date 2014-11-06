module GDS
  module SSO
    module ControllerMethods
      def authenticate_user!
        if Rails.env.docker?
          current_user = GDS::SSO::Config.user_klass.first
        else
          warden.authenticate!
        end
      end

      def warden
        request.env['warden']
      end
    end
  end
end
