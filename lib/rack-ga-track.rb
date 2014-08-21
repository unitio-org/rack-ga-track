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
        create_cookie(response[1], params)
      end
      response
    end

    private

    def set_params(req)
      if req.params['utm_source']
        return params_hash(req)
      elsif req.cookies['ga_track'] && !req.cookies['ga_track'].empty?
       return JSON.parse(req.cookies['ga_track'])
      end
      false
    end

    def params_hash(req)
      {
        source: req.params['utm_source'],
        medium: req.params['utm_medium'],
        term: req.params['utm_term'],
        content: req.params['utm_content'],
        campaign: req.params['utm_campaign'],
        referer: req.referer,
        landing_page: req.path,
        time: Time.now.to_i
      }
    end

    def create_cookie(headers, params)
      expires = Time.now + @cookie_ttl
      cookie_hash = { value: JSON.generate(params), expires: expires, path: '/' }
      cookie_hash[:domain] = @cookie_domain if @cookie_domain
      Rack::Utils.set_cookie_header!(headers, 'ga_track', cookie_hash)
    end

    def create_env_vars(env, params)
      params.each do |key, value|
        env["ga_track.#{key.to_s}"] = value
      end
    end
  end
end
