require "gemma/version"
require "net/smtp"

module Gemma
  class Sender
    def send_message
      puts "Enter your GMail username:"

      username = gets.chomp

      puts "Enter your password:"

      password = gets.chomp

      puts "Enter the recipient's Email address"

      recipient = gets.chomp

      puts "What is the subject of the email?"

      subject_line = gets.chomp

      puts "Enter your message:"

      message = gets.chomp

      smtp = Net::SMTP.new('smtp.gmail.com', 587)

      smtp.enable_starttls

      smtp.start('gmail.com', username, password, :login) do
        smtp.send_message(message, username, recipient)   
      end
      
    end
  end
end
