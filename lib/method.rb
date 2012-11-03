module Gmailer
	def generate username, password
	
		if (username != "" && password != "")
			#Check to see if there this already exists in enviornmnet.rb
			File.new("file.rb", "w")
			file = File.open("file.rb");
			file.puts("module file");
			file.puts("\t#Username: " + username)
			file.puts("\t#Password: " + password)
			file.puts("\nend")
			file.close
		else
			puts "Error. Please provide a username and a password for your GMail account."
		end
	
	end
end