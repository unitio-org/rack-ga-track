module Rack
  class GaTrack

    def initialize(app, opts = {})
      @app = app
      @cookie_ttl = opts[:ttl] || 60*60*24*30
      @cookie_domain = opts[:domain] || nil
    end

    def call(env)
      req = Rack::Request.new(env)

      params = set_params(req)
      if params
        create_env_vars(env, params)
      end

      response = @app.call(env)
      if params && req.params['utm_source']
        create_cookies(response[1], params)
      end
      response
    end

    private

    def set_params(req)
      if req.params['utm_source']
        return params_hash(req.params)
      elsif req.cookies['utm_source']
       return params_hash(req.cookies)
      end
      false
    end

    def params_hash(params)
      params['utm_time'] ||= Time.now

      {
        source: params['utm_source'],
        medium: params['utm_medium'],
        term: params['utm_term'],
        content: params['utm_content'],
        campaign: params['utm_campaign'],
        time: params['utm_time'].to_i
      }
    end

    def create_cookies(headers, params)
      expires = Time.now + @cookie_ttl
        params.each do |key, value|
          cookie_hash = {:value => value, :expires => expires}
          cookie_hash[:domain] = @cookie_domain if @cookie_domain
          cookie_key = 'utm_' + key.to_s
          Rack::Utils.set_cookie_header!(headers, cookie_key, cookie_hash)
      end
    end

    def create_env_vars(env, params)
      params.each do |key, value|
        env["ga_track.#{key.to_s}"] = value
      end
    end
  end
end
