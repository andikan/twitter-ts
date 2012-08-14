#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'

#screen_name = String.new ARGV[0]

Twitter.configure do |config|
  config.consumer_key = "qr7DUTlTG0yL35mtUHz7g"
  config.consumer_secret = "vAKUFH5AgaTexaybNPmewoWC0GAK9ftiWQdTp1DL0"
  config.oauth_token = "608427831-8CKLOkFAGL1neZHQxd7cyxBZgCofKmdNa9HYdg3R"
  config.oauth_token_secret = "Z7rDSWw5SyEsQ1KzHuuBWJmVF6X7eV5D1hCyKY2gU"
end

puts Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"
begin
	#a_user = Twitter.user(screen_name)
	#user_id = a_user.id
	#puts a_user
	#puts "id = "+user_id.to_s
	puts Twitter.home_timeline.first.text


rescue Twitter::Error => e
	puts e.to_s
	sleep(60)
	exit
end

puts Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"
