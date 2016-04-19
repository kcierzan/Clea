require "clea/version"
require "net/smtp"
require "pstore"
require "ValidateEmail"

module Clea
  class Sender

    # Retrieve valid info from the persistent hash or from user input
    def write_sender_info
      # Initialize or open persistent user info hash
      @sender_info = PStore.new("my-clea-info.pstore")

      # If there is no persisting value for from_address, get values for alias, from_address, and password
      senders_from = @sender_info.transaction { sender_info[:from_address] }

      if senders_from == nil
        # Get user's alias and confirm
        alias_confirmed = false
        puts "What is your name?"
        while from_alias = gets.chomp
          catch :badalias do
            puts "Are you sure your name is #{from_alias}? [y/n]:"
            while alias_confirmation = gets.chomp
              case alias_confirmation
              when 'y'
                alias_confirmed = true
                break
              else
                puts "Please re-enter your name:"
                throw :badalias
              end
            end
          end
        end

        # Get user's email address, validate, confirm
        puts "Enter your gmail address:"
        while from_address = gets.chomp
          catch :badfrom do
            case from_address
            when ValidateEmail.validate(from_address, true) == true
              puts "Is your email address #{from_address}? [y/n]:"
              while address_confirmation = gets.chomp
                throw :badfrom unless address_confirmation == 'y'
                break
              end
            else
              puts "Email invalid! Please enter a valid email address:"
            end
          end
        end

        # Get user's password and confirm
        pass_confirmed = false
        puts "Enter your password:"
        while password = gets.chomp && confirmed == false
          catch :badpass do
            puts "Are you sure your password is #{password}? [y/n]:"
            while pass_confirmation = gets.chomp
              case pass_confirmation
              when 'y'
                pass_confirmed = true
                break
              else
                puts "Please re-enter your password:"
                throw :badpass
              end
            end
          end
        end

        # Write input password, from_address, and from_alias to persistent hash
        sender_info.transaction do
          sender_info[:password] = password
          # Abort user info storage if the entered from_address is invalid
          # sender_info.abort unless ValidateEmail.validate(from_address, true) == true
          sender_info[:from_address] = from_address
          sender_info[:from_alias] = from_alias
        end
      end
    end

    def get_msg_info
      puts "Enter the recipient's email address:"
      while @to_address = gets.chomp
        catch :badto do
          case to_address
          when ValidateEmail.validate(to_address, true) == true
            puts "Is the recipient's email address #{to_address}? [y/n]:"
            while to_address_confirmation = gets.chomp
              throw :badto unless to_address_confirmation == 'y'
              break
            end
          else
            puts "Email invalid! Please enter a valid email address:"
          end
        end
      end

      puts "What is the subject of the email?"
      @subject_line = gets.chomp

      puts "Enter your message:"
      @body = gets.chomp
    end



    # Interpolate user info into message string
    def compose
      # Read from persistent sender_info hash and assign variables


      # Compose message
      @msg = <<-END_OF_MESSAGE
      From: #{sender_info[:from_alias]} <#{sender_info[:from_address]}>
      To: <#{@to_address}>
      Subject: #{@subject_line}

      #{@body}
      END_OF_MESSAGE
    end

    # Open SMTP connection, pass user info as arguments, send message and close connection
    def send_message
      # Read the user's password from the persistent hash
      password = @sender_info.transaction { sender_info[:password] }
      # Initialize the gmail SMTP connection
      smtp = Net::SMTP.new('smtp.gmail.com', 587)
      #Upgrade connection to SSL/TLS
      smtp.enable_starttls


      # Open SMTP connection, send message, close the connection
      smtp.start('gmail.com', sender_info[:from_address], password, :login) do
        smtp.send_message(msg, sender_info[:from_address], recipient)
      end
    end

  end
end
