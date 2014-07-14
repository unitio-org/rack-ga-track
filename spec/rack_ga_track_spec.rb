require 'helper'

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
      get '/', {utm_source: 'testing', utm_campaign: 'email', utm_content: 'test_content'}
    end

    last_request.env['ga_track.source'].must_equal "testing"
    last_request.env['ga_track.campaign'].must_equal "email"
    last_request.env['ga_track.content'].must_equal "test_content"
    last_request.env['ga_track.time'].must_equal @time.to_i
  end

  it "should save GA Campaign params in a cookie" do
    Timecop.freeze do
      @time = Time.now
      get '/', {utm_source: 'testing', utm_campaign: 'email', utm_content: 'test_content'}
    end

    rack_mock_session.cookie_jar["utm_source"].must_equal "testing"
    rack_mock_session.cookie_jar["utm_campaign"].must_equal "email"
    rack_mock_session.cookie_jar["utm_content"].must_equal "test_content"
    rack_mock_session.cookie_jar["utm_time"].must_equal "#{@time.to_i}"
  end

  describe "when cookie exists" do
    before :each do
      @time = Time.now
      clear_cookies
      set_cookie("utm_source=testing")
      set_cookie("utm_campaign=email")
      set_cookie("utm_content=test_content")
      set_cookie("utm_time=#{@time.to_i}")
    end

    it "should restore GA Campaign params from cookie" do
      Timecop.freeze do
        get '/'
      end

      last_request.env['ga_track.source'].must_equal "testing"
      last_request.env['ga_track.campaign'].must_equal "email"
      last_request.env['ga_track.content'].must_equal "test_content"
      last_request.env['ga_track.time'].must_equal @time.to_i
    end

    it 'should not update existing cookie' do
      Timecop.freeze(60*60*24) do
        get '/'
      end

      last_request.env['ga_track.source'].must_equal "testing"
      last_request.env['ga_track.campaign'].must_equal "email"
      last_request.env['ga_track.content'].must_equal "test_content"
      last_request.env['ga_track.time'].must_equal @time.to_i

      rack_mock_session.cookie_jar["utm_source"].must_equal "testing"
      rack_mock_session.cookie_jar["utm_campaign"].must_equal "email"
      rack_mock_session.cookie_jar["utm_content"].must_equal "test_content"
      rack_mock_session.cookie_jar["utm_time"].must_equal "#{@time.to_i}"
    end
  end
 end
