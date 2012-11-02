require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Douban < OmniAuth::Strategies::OAuth2
      option :name, 'douban'

      option :client_options, {
        :site          => 'https://api.douban.com',
        :authorize_url => 'https://www.douban.com/service/auth2/auth',
        :token_url     => 'https://www.douban.com/service/auth2/token'
      }

      option :token_params, {
        :parse => :json,
      }

      uid do
        raw_info['id']
      end

      info do
        {
          :uid         => raw_info['uid'],
          :name        => raw_info['name'],
          :loc_id      => raw_info['loc_id'],
          :loc_name    => raw_info['loc_name'],
          :avatar      => raw_info['avatar'],
          :alt         => raw_info['alt'],
          :desc        => raw_info['desc'],
          :created     => raw_info['created'],
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        access_token.options[:param_name] = 'access_token'
        @raw_info ||= access_token.get("/v2/user/~me").parsed
      rescue ::Timeout::Error => e
        raise e
      end

    end
  end
end

OmniAuth.config.add_camelization 'douban', 'Douban'