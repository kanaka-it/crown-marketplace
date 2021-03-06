module Cognito
  class Token
    class VerificationFailure < StandardError; end

    def initialize(token)
      @token = token
    end

    def subject
      @token['sub']
    end

    def email
      @token['email']
    end

    def verify!(user_pool)
      raise VerificationFailure, 'issuer is invalid' unless @token['iss'] == user_pool.idp_url
      raise VerificationFailure, 'token has expired' unless Time.now.to_i < @token['exp']
      raise VerificationFailure, 'audience is invalid' unless @token['aud'] == user_pool.app_client_id

      self
    end
  end
end
