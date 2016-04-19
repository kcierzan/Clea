require "clea/version"
require "net/smtp"
require "pstore"
require "ValidateEmail"

module Clea
  class Sender

    def send_message
      # Initialize the gmail SMTP connection
      smtp = Net::SMTP.new('smtp.gmail.com', 587)
      #Upgrade connection to SSL/TLS
      smtp.enable_starttls

      # Open SMTP connection, send message, close the connection
      smtp.start('gmail.com', user_info[:from_address], user_info[:password], :login) do
        smtp.send_message(msg, user_info[:from_address], recipient)
      end
    end

    def fetch_and_compose
      # Read from persistent user_info hash and assign variables


      # Compose message
      msg = <<-END_OF_MESSAGE
      From: #{user_info[:from_alias]} <#{user_info[:from_address]}>
      To: <#{recipient}>
      Subject: #{subject_line}

      #{body}
      END_OF_MESSAGE
    end

    def get_info
      # Initialize or open persistent user info hash
      @user_info = PStore.new("user-info.pstore")

      # If there is no persisting value for from_address, get values for alias, from_address, and password
      if user_info[:from_address] == nil
        puts "What is your name?"
        from_alias = gets.chomp


        puts "Enter your GMail address:"
        while from_address = gets.chomp
          catch :unconfirmed do
            case from_address
            when ValidateEmail.validate(from_address, true) == true
              puts "Is your email address #{from_address}? [y/n]:"
              while confirmation = gets.chomp
                throw :unconfirmed unless confirmation == 'y'
                break
              end
            else
              puts "Email invalid! Please enter a valid email address:"
            end
          end
        end

        puts "Enter your password:"
        password = gets.chomp

        # Write input password, from_address, and from_alias to persistent hash
        user_info.transaction do
          user_info[:password] = password
          # Abort user info storage if the entered from_address is invalid
          # user_info.abort unless ValidateEmail.validate(from_address, true) == true
          user_info[:from_address] = from_address
          user_info[:from_alias] = from_alias
        end
      else
        puts "Enter the recipient's Email address"
        @recipient = gets.chomp

        if ValidateEmail.validate(@recipient, true) == false
          puts "What is the subject of the email?"
          @subject_line = gets.chomp

          puts "Enter your message:"
          @body = gets.chomp
        end
      end
    end
  end
end
