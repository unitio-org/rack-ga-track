Rack::GaTrack
================

Rack::GaTrack is a rack middleware that extracts Google Analytics Campaign
params from the request. Specifically, it looks for a param utm\_source in the request.
If found, it creates a cookie with utm\_source, utm\_content, utm\_term,
utm\_campaign, and time.

Use Case
---------------
Let's say you want to track signups in your app from a specific campaign.

1. A user clicks a link on an external site that has your Google Analytics
   Campaign params in the request.
2. Rack::GaTrack finds utm\_source param in the
   request and parses the other Google Analytics Campaign params from the request and saves them in a cookie.
3. If a user signs up now or in the future you can read the Google Analytics
   Campaign params from the env variables that Rack::GaTrack creates and save
   them to the created user record.

Installation
------------
gem install rack-ga-track

Rails 4 Example Usage
---------------------

Add the Rack::GaTrack to your application stack:

    #Rails 4 in config/application.rb
    class Application < Rails::Application
      config.middleware.use Rack::GaTrack
    end

You can now access your Google Analytics Campaign params in
<code>request.env['ga\_track.source']</code>
<code>request.env['ga\_track.term']</code>
<code>request.env['ga\_track.content']</code>
<code>request.env['ga\_track.campaign']</code>
<code>request.env['ga\_track.medium']</code>

Customization
-------------

By default cookie is set for 30 days, you can extend time to live with <code>:ttl</code> option (default is 30 days).

    #Rails 4 in config/application.rb
    class Application < Rails::Application
      config.middleware.use Rack::Affiliates, :ttl => 3.months
    end

The <code>:domain</code> option allows to customize cookie domain.

    #Rails 4 in config/application.rb
    class Application < Rails::Application
      config.middleware.use Rack::Affiliates, :domain => '.example.org'
    end

Rack::GaTrack will set cookie on <code>.example.org</code> so it's accessible on <code>www.example.org</code>, <code>app.example.org</code> etc.
