class Gmailer
	def self.generate username, password
			
		if !(username.nil? || password.nil?)
		
			helper = Thingies.new(username, password)
		
			#Check to see if there if the gmailer file already exists
			puts "Checking files..."
			
			if !helper.check_files?
				puts "Error, you already have an emailer system in place. Please remove all traces of the emailer system before generating a new one."
				return false
			end
		
			puts "Ready to go!"
			#Add email info to the end of environment.rb
			file = File.open("config/environment.rb", "a")
			file.puts helper.get_text(:environment)
			file.close
			
			puts "Modified config/environment.rb"
			
			#Generate file for mailer
			
		else
			puts "Error. Please put your gmail username and password."
		end
		
	end
end	

class Gmailer::Thingies

	def initialize(username, password)
		@username = username
		@password = password
	end

	def check_files?
		#Environment
		if !File.exists? "config/environment.rb"
			return false
		end
		
		file = File.open("config/environment.rb", "r")
		ex = false
		file.each do |line|
			if line.include? "ActionMailer::Base.delivery_method = :smtp"
				ex = true
			end
		end
		
		if ex == true
			return false
		end
		
		#Check for directory
		if File.directory? "app/emailer"
			return false
		end
		
		#Check for templates
		if ((File.exists? "app/views/email_plain.html.erb") || (File.exists? "app/views/email_html.html.erb"))
			return false
		end
		
		true
		
	end
	
	
	def get_text(text)
		if (text == :environment)
			"
			
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
	:address => \"smtp.gmail.com\",
	:port => 587,
	:authentication => :plain,
	:user_name => \"" + @username + "\",
	:password => \"" + @password + "\",
	:enable_starttls_auto => true,
	:openssl_verify_mode => \"none\"
}"
		end
	end
end