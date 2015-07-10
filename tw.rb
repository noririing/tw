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

topics = []
File.open("keywords.txt") do  | f |
  f.each_line do | line |
    topics.push(line.chomp!)
  end
end

begin
  csv_f = File.open("tw.csv","a")
  client.filter(:track => topics.join(",") ) do |obj|
    if obj.user.lang == "ja" && !obj.text.index("RT")
      csv_f.write("\"#{Time.parse(obj.created_at.to_s).getlocal}\"\,\"#{obj.user.screen_name}\"\,\"#{obj.text.gsub(/(\s|\,|\"|\')/," ")}\"\n")
      csv_f.flush
    end
  end
rescue
  csv_f.close
  retry
end
