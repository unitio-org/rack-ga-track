require 'helper'
require 'json'

describe "RackGaTrack" do
  before :each do
    clear_cookies
  end

  it "should handle empty GA Campaign params" do
    get '/'

    last_request.env['ga_track.source'].must_equal nil
    last_request.env['ga_track.term'].must_equal nil
    last_request.env['ga_track.campaign'].must_equal nil
    last_request.env['ga_track.content'].must_equal nil
    last_request.env['ga_track.medium'].must_equal nil
    last_request.env['ga_track.time'].must_equal nil
  end

  it "should set ga_track env vars from params" do
    Timecop.freeze do
      @time = Time.now
      params = { utm_source: 'testing',
                 utm_campaign: 'email',
                 utm_medium: 'test_medium' }

      get '/', params
    end

    last_request.env['ga_track.source'].must_equal "testing"
    last_request.env['ga_track.campaign'].must_equal "email"
    last_request.env['ga_track.medium'].must_equal "test_medium"
    last_request.env['ga_track.time'].must_equal @time.to_i
  end

  it "should save GA Campaign params in a cookie" do
    Timecop.freeze do
      @time = Time.now
      params = { utm_source: 'testing',
                 utm_campaign: 'email',
                 utm_medium: 'test_medium' }

      get '/', params
    end

    cookie_params = JSON.parse(rack_mock_session.cookie_jar["ga_track"])

    cookie_params["source"].must_equal "testing"
    cookie_params["campaign"].must_equal "email"
    cookie_params["medium"].must_equal "test_medium"
    cookie_params["time"].must_equal @time.to_i
  end

  describe "when cookie exists" do
    before :each do
      @time = Time.now
      clear_cookies
      @params = { source: 'testing',
                  campaign: 'email',
                  medium: 'test_medium',
                  time: @time.to_i }
      rack_mock_session.cookie_jar["ga_track"] = @params.to_json
    end

    it "should restore GA Campaign params from cookie" do
      Timecop.freeze do
        get '/'
      end

      last_request.env['ga_track.source'].must_equal "testing"
      last_request.env['ga_track.campaign'].must_equal "email"
      last_request.env['ga_track.medium'].must_equal "test_medium"
      last_request.env['ga_track.time'].must_equal @time.to_i
    end

    it 'should not update existing cookie' do
      Timecop.freeze(60*60*24) do
        get '/'
      end

      last_request.env['ga_track.source'].must_equal "testing"
      last_request.env['ga_track.campaign'].must_equal "email"
      last_request.env['ga_track.medium'].must_equal "test_medium"
      last_request.env['ga_track.time'].must_equal @time.to_i

      rack_mock_session.cookie_jar["ga_track"].must_equal JSON.generate(@params)
    end

    it 'should update existing cookie if utm_source is present in url params' do
      Timecop.freeze(60*60*24) do
        params = { utm_source: 'cool_source',
                   utm_campaign: 'email',
                   utm_medium: 'test_medium' }

        get '/', params
      end
      cookie_params = JSON.parse(rack_mock_session.cookie_jar["ga_track"])

      cookie_params["source"].must_equal "cool_source"
    end
  end
 end
