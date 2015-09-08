# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

use Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000', 'walter-cavinaw.github.io'
            /http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
    # regular expressions can be used here

    resource '/*', :headers => 'x-domain-token'
    resource '/backtests',
             :methods => [:get, :post, :put, :delete, :options],
             :headers => ['Origin', 'Accept', 'Content-Type'],
             :max_age => 600
    # headers to expose
  end

  allow do
    origins '*'
    resource '/*', :headers => :any, :methods => [:get, :post]
  end
end

run Rails.application
