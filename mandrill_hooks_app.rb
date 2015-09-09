require 'json'

class MandrillHooksApp < Sinatra::Base
  post "/" do
    data = JSON.parse(request.body.read)
    StatsService.store event: data["Event"], type: data['EmailType']
    200
  end

  get '/stats' do
    @data = StatsService.data
    erb :stats
  end
end
