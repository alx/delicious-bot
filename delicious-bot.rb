#!/usr/bin/env ruby
require 'rubygems'
require 'jabber/bot'
require 'rdelicious'
require 'YAML'

###
### initialize configuration
###

@bot_settings = YAML::load_file("config.yml")

###
### Bot
###

bot = Jabber::Bot.new(
  :jabber_id => @bot_settings["jabber_id"], 
  :password  => @bot_settings["jabber_password"], 
  :master    => @bot_settings["jabber_master"],
  :is_public => true
)

###
### Delicious configuration
###

delicious = Rdelicious.new(@bot_settings["delicious_login"], @bot_settings["delicious_password"])

bot.add_command(
  :syntax      => 'bookmark <url> [description]',
  :description => 'Bookmark link to delicious',
  :regex       => /^bookmark\s+.+$/,
  :alias       => [ 
      :syntax => 'b <url> [description]', 
      :regex => /^b\s+.+$/
  ]
) do |sender, message|
  url = message.slice!(/^.[^\s]*/)
  delicious.add(url, message.strip) if delicious.is_connected?
  nil
end

###
### Life!
###

bot.connect
