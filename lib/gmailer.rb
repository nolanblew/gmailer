class Gmailer
	def self.generate username, password
			
		if !(username.nil? || password.nil?)
		
			helper = Thingies.new(username, password)
		
			#Check to see if there if the gmailer file already exists
			puts "\tChecking files..."
			
			if !helper.check_files?
				puts "\tError, you already have an emailer system in place. Please remove all traces of the emailer system before generating a new one."
				return false
			end
		
			puts "\tReady to go!"
			#Add email info to the end of environment.rb
			file = File.open("config/environment.rb", "a")
			file.puts helper.get_text(:environment)
			file.close
			
			puts "\tModified config/environment.rb"
			
			#Generate file for mailer
			if (!File.directory? "app/mailers")
				Dir.mkdir("app/mailers", 755)
				puts "\tCreated mailer directory"
			end
			file = File.new("app/mailers/gmailer.rb", "w")
			file.puts helper.get_text(:emailer)
			file.close
			puts "\tAdded Mailer in app/mailers/gmailer.rb"
			
			#Generate email scaffolds
			if (!File.directory? "app/views/gmailer")
				Dir.mkdir("app/views/gmailer")
				puts "\tCreated views/gmailer directory"
			end
			
			file = File.new("app/views/gmailer/email_plain.html.erb", "w")
			file.puts helper.get_text(:plain)
			file.close
			puts "\tAdded plain text email scaffold in app/views/gmailer/email_plain.html.erb"
			
			file = File.new("app/views/gmailer/email_html.html.erb", "w")
			file.puts helper.get_text(:html)
			file.close
			puts "\tAdded HTML scaffold in app/views/gmailer/email_html.html.erb"
			
			puts "\nComplete! Edit the email scaffolds with your email (and dynamic text)."
			puts "To send an email, in the controller use: Gmailer.email([to address], [subject]).deliver"
			
		else
			puts "\tError. Please put your gmail username and password."
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
		if File.directory? "app/mailers"
			if File.exists? "app/mailers/gmailer.rb"
				return false
			end
		end
		
		#Check for templates
		if ((File.exists? "app/views/gmailer/email_plain.html.erb") || (File.exists? "app/views/gmailer/email_html.html.erb"))
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
		
		elsif (text == :emailer)
			"class Gmailer < ActionMailer::Base
  default :from => \"#{@username}\"
  def email(recipient, subject)
	mail(:to =>	recipient, :subject => subject) do |format|
		format.text { render \"email_plain.html.erb\" }
		format.html { render \"email_html.html.erb\" }
	end
  end
end"

		elsif (text == :plain)
			"This is a sample email.
			Your system works!
			
			YIPPEEE!!!!"
			
		elsif (text == :html)
			"This is a sample email.</br>
			<span style='color:green'>Your system <b>works!</b></span><br/><br/>
			
			YIPEEEEE!!!!"
		end
	end
end