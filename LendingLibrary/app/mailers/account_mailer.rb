class AccountMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: ENV["account_email_username"]
  
   @@smtp_settings = {
      :address              => ENV["email_addr"],
      :port                 => ENV["email_port"],
      :authentication       => ENV["email_auth"],
      :user_name            => ENV['account_email_username'],
      :password             => ENV['account_password'],
      :enable_starttls_auto => ENV['tls_auto']
    }
    
    # send password reset instructions
    def reset_password_instructions(user)
     @resource = user
     mail(:to => @resource.email, :subject => "Reset password instructions", :tag => 'password-reset', :content_type => "text/html") do |format|
       format.html { render "devise/mailer/reset_password_instructions" }
     end
    end
    
    
    
    def welcome(user, password)
        @user = user
        @password = password
        mail(to: @user.email, subject: "Welcome to TEP's Lending Library!", :tag => "Welcome to TEP!")
        mail.delivery_method.settings.merge! @@smtp_settings
        mail
    end

end