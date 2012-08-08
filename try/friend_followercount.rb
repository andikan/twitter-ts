#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'



screen_name = String.new ARGV[0]

Twitter.configure do |config|
  config.consumer_key = "qr7DUTlTG0yL35mtUHz7g"
  config.consumer_secret = "vAKUFH5AgaTexaybNPmewoWC0GAK9ftiWQdTp1DL0"
  config.oauth_token = "608427831-8CKLOkFAGL1neZHQxd7cyxBZgCofKmdNa9HYdg3R"
  config.oauth_token_secret = "Z7rDSWw5SyEsQ1KzHuuBWJmVF6X7eV5D1hCyKY2gU"
end

begin
	a_user = Twitter.user(screen_name)
	friends = Twitter.friend_ids(screen_name)
rescue Twitter::Error => e
	puts e.to_s
	exit
end

user = {}


friends.ids.each do |fid|
	begin
	  f = Twitter.user(fid)
	  # Only iterate if we can see their followers
	  if (f.protected.to_s != "true")
	    user[f.screen_name.to_s] = f.followers_count
	    puts "friend name : "+f.screen_name.to_s+" , friend's followers count : "+f.followers_count.to_s
	  end

	rescue Twitter::Error => e
		# display the error message  
  		puts e.to_s
  		sleep(2)
  		retry
  	end
end

#user.sort_by {|k,v| -v}.each { |user, count| puts "#{user}, #{count}" }