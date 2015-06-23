#!/usr/bin/env ruby
# coding: utf-8

require "twitter"
require "yaml"

twconf = YAML.load_file("tw.yml")
client = Twitter::Streaming::Client.new do | config |
  config.consumer_key               =  twconf["consumer_key"]
  config.consumer_secret            =  twconf["consumer_secret"]
  config.access_token               =  twconf["access_token"]
  config.access_token_secret        =  twconf["access_token_secret"]
end

#client.sample do |object|
#  if object.is_a?(Twitter::Tweet)
#    if object.lang == "ja" && object.user.lang == "ja"  && !object.retweeted?
#      print #{object.created_at} , #{object.user.name.chomp} , #{object.text.chomp}
#    end
#  end
#end

topics = ["スタバ"]
client.filter(:track => topics.join(",") ) do |status|
  if status.user.lang == "ja" && !status.text.index("RT")
    puts "#{status.user.screen_name}: #{status.text}"
  end
end

#client.filter( :locations => '132.2,29.9,146.2,39.0,138.4,33.5,146.1,46.20' ) do | object |
#  if object.is_a?(Twitter::Tweet)
#    if object.lang == "ja" && object.user.lang == "ja"  && !object.retweeted?
#        print #{object.created_at} , #{object.user.name.chomp} , #{object.text.chomp}
#    end
#  end
#end
