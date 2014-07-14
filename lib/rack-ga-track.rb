module Rack
  class GaTrack

    def initialize(app, opts = {})
      @app = app
      @cookie_ttl = opts[:ttl] || 60*60*24*30
      @cookie_domain = opts[:domain] || nil
    end

    def call(env)
      req = Rack::Request.new(env)
      status, headers, body = @app.call(env)

      args = {}

      if req.cookies['utm_source']
        args = params_hash(req.cookies)
      elsif req.params['utm_source']
        args = params_hash(req.params)
        create_cookies(headers, args)
      end

      unless args.empty?
        create_env_vars(env, args)
      end

      [status, headers, body]
    end

    private

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

    def create_cookies(headers, args)
      expires = Time.now + @cookie_ttl
        args.each do |key, value|
          cookie_hash = {:value => value, :expires => expires}
          cookie_hash[:domain] = @cookie_domain if @cookie_domain
          cookie_key = 'utm_' + key.to_s
          Rack::Utils.set_cookie_header!(headers, cookie_key, cookie_hash)
      end
    end

    def create_env_vars(env, args)
      args.each do |key, value|
        env["ga_track.#{key.to_s}"] = value
      end
    end
  end
end
