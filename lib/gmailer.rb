class Gmailer
	def self.generate username, password
			
		if !(username == "" || password == "")
			File.new("tmp.txt", "w")
			file = File.open("tmp.txt")
			file.puts "username: " + username
			file.puts "password: " + password + "\n"
			file.close()
			puts "Generated temporary file."
		else
			puts "Error. Please put your gmail username and password."
		end
	end
end