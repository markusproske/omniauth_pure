# taken from https://github.com/ballantyne/omniauth-renren/blob/master/lib/omniauth/strategies/renren.rb
# lots of stuff taken from https://github.com/yzhang/omniauth/commit/eafc5ff8115bcc7d62c461d4774658979dd0a48e

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Renren < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :authorize_url => 'http://graph.renren.com/oauth/authorize',
        :token_url => 'http://graph.renren.com/oauth/token',
        :site => 'http://graph.renren.com'
      }

      uid { raw_info['uid'] }

      info do
        {
          "uid" => raw_info["uid"], 
          "gender"=> (raw_info["sex"] == 1 ? 'Male' : 'Female'), 
          "image"=>raw_info["headurl"],
          'name' => raw_info['name'],
          'urls' => {
            'Renren' => "http://www.renren.com/profile.do?id="+raw_info["uid"].to_s
          }
        }
      end
      
      def signed_params
        params = {}
        params[:api_key] = client.id
        params[:method] = 'users.getInfo'
        params[:call_id] = Time.now.to_i
        params[:format] = 'json'
        params[:v] = '1.0'
        params[:uids] = session_key['user']['id']
        params[:session_key] = session_key['renren_token']['session_key']
        params[:sig] = Digest::MD5.hexdigest(params.map{|k,v| "#{k}=#{v}"}.sort.join + client.secret)
        params
      end

      def session_key
        response = @access_token.get('/renren_api/session_key', {:params => {:oauth_token => @access_token.token}})
        @session_key ||= MultiJson.decode(response.response.env[:body])
      end

      #http://wiki.dev.renren.com/wiki/%E6%9D%83%E9%99%90%E5%88%97%E8%A1%A8
      def request_phase
        options[:scope] ||= 'publish_feed'
        super
      end

      def build_access_token
        if renren_session.nil? || renren_session.empty?
          verifier = request.params['code']
          self.access_token = client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(options))
          puts self.access_token.inspect
          self.access_token
        else
          self.access_token = ::OAuth2::AccessToken.new(client, renren_session['access_token'])
        end
      end

      def renren_session
        session_cookie = request.cookies["rrs_#{client.id}"]
        if session_cookie
          @renren_session ||= Rack::Utils.parse_query(request.cookies["rrs_#{client.id}"].gsub('"', ''))
        else
          nil
        end
      end

      def raw_info
        @raw_info ||= MultiJson.decode(Net::HTTP.post_form(URI.parse('http://api.renren.com/restserver.do'), signed_params).body)[0]
        @raw_info
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end