require "clea/version"
require "net/smtp"
require "pstore"
require "ValidateEmail"

module Clea
  class Sender
    # Set up persistent user info hash and return the user's email address if it already exists
    def check_sender_info
      @sender_info = PStore.new("my-clea-info.pstore")
      senders_from = @sender_info.transaction { @sender_info[:from_address] }
      return senders_from
    end

    # Get user's alias and confirm
    def get_sender_alias
      puts "What is your name?"
      while @from_alias = gets.chomp
        catch :badalias do
          puts "Are you sure your name is #{@from_alias}? [y/n]:"
          while alias_confirmation = gets.chomp
            case alias_confirmation
            when 'y'
              return
            else
              puts "Please re-enter your name:"
              throw :badalias
            end
          end
        end
      end
    end

    # Get, validate, and confirm user's email address
    def get_sender_gmail
      puts "Enter your gmail address:"
      while @from_address = gets.chomp
        catch :badfrom do
          if ValidateEmail.validate(@from_address) == true
            puts "Is your email address #{@from_address}? [y/n]:"
            while address_confirmation = gets.chomp
              case address_confirmation
              when 'y'
                return
              else
                puts "Please re-enter your gmail address:"
                throw :badfrom
              end
            end
          else
            puts "Email invalid! Please enter a valid email address:"
          end
        end
      end
    end

    # Get and confirm user's password
    def get_sender_password
      puts "Enter your password:"
      while @password = gets.chomp
        catch :badpass do
          puts "Are you sure your password is #{@password}? [y/n]:"
          while pass_confirmation = gets.chomp
            case pass_confirmation
            when 'y'
              return
            else
              puts "Please re-enter your password:"
              throw :badpass
            end
          end
        end
      end
    end

    # Write all user info to the persistent hash
    def write_sender_data
      @sender_info.transaction do
        @sender_info[:password] = @password
        @sender_info[:from_address] = @from_address
        @sender_info[:from_alias] = @from_alias
      end
    end

    # Get, validate, and confirm the recipient's email address. This data does not persist.
    def get_recipient_data
      puts "Enter the recipient's email address:"
      while @to_address = gets.chomp
        catch :badto do
          if ValidateEmail.validate(@to_address) == true
            puts "Is the recipient's email address #{@to_address}? [y/n]:"
            while to_address_confirmation = gets.chomp
              case to_address_confirmation
              when 'y'
                return
              else
                puts "Please re-enter the recipient's email address:"
                throw :badto
              end
            end
          else
            puts "Email invalid! Please enter a valid email address:"
          end
        end
      end
    end

    # Get message content
    def get_message
      puts "What is the subject of the email?"
      @subject_line = gets.chomp

      puts "Enter your message:"
      @body = gets.chomp
    end

    # Compose message as heredoc
    def compose
      # Read from persistent user info hash and assign instance variables
      @stored_from_alias = @sender_info.transaction { @sender_info[:from_alias] }
      @stored_from_address = @sender_info.transaction { @sender_info[:from_address] }
      @msg = <<-END_OF_MESSAGE
From: #{@stored_from_alias} <#{@stored_from_address}>
To: <#{@to_address}>
Subject: #{@subject_line}

#{@body}
      END_OF_MESSAGE
    end

    # Open SMTP connection, pass user info as arguments, send message and close connection
    def send_message
      # Read the user's password from the persistent hash
      stored_password = @sender_info.transaction { @sender_info[:password] }
      # Initialize the gmail SMTP connection and upgrade to SSL/TLS
      smtp = Net::SMTP.new('smtp.gmail.com', 587)
      smtp.enable_starttls
      # Open SMTP connection, send message, close the connection
      smtp.start('gmail.com', @stored_from_address, stored_password, :login) do
        smtp.send_message(@msg, @_stored_from_address, @to_address)
      end
    end

  end
end
