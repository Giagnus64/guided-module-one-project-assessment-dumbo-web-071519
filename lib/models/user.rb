class User < ActiveRecord::Base 
    has_many :heros

    def self.prompt 
        TTY::Prompt.new
    end


    def self.handle_new_user
       puts "The dungeons await..."
       # asks for email and validates using TTY PROMPT
       name = self.prompt.ask("Enter a username")
       email = self.prompt.ask("Enter your email address - (this will be used for login purposes only).") { |q| q.validate :email }
       if check_email(email)
            self.prompt.keypress("There is already a user associated with this email!", timeout: 2)
            self.handle_new_user
       else
       new_user = User.create({
           name: name,
           email: email
       })
       end
       return new_user
    end

    def self.handle_returning_user(string)
         puts string
         email = self.prompt.ask("Enter your email address.") { |q| q.validate :email }
         users = self.all.select {|user| user.email == email }
         if users.length == 0
            self.handle_returning_user("There's no adventurer with that email! Please re-enter your email!")
         else 
            ## check user already has a hero with this email
            return users[0]
         end
    end
    
    def self.check_email(email)
        if self.get_user_emails.include?(email)
            return true
        else 
            return false
        end
    end
    
    def self.get_user_emails
        self.all.map{|user| user.email}
    end

    
end