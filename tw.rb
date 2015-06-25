#!/usr/bin/env ruby
# coding: utf-8

#require "twitter"
require "tweetstream"
require "time"
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

csv_f = File.open("tw.csv","a")

topics = ["スタバ","starbucks","スターバックス","ドトール","ベローチェ","タリーズ","tullys","コメダ","ルノアール","サンマルクカフェ","サンマルク","プロント","エクセルシオール","。"]
client.filter(:track => topics.join(",") ) do |obj|
  if obj.user.lang == "ja" && !obj.text.index("RT")
    csv_f.write("\"#{Time.parse(obj.created_at.to_s).getlocal}\"\,\"#{obj.user.screen_name}\"\,\"#{obj.text.gsub(/(\s|\,|\"|\')/," ")}\"\n")
    csv_f.flush
  end
end

csv_f.close
