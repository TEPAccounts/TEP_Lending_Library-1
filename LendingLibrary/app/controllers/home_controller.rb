require 'csv' 
require 'tempfile'


class HomeController < ApplicationController
  layout 'home'

  def home
  end

  def about
  end

  def contact
  end

  def upload_users
  end

  def create_users
  	failed_emails = Array.new
  	file = params['create_users']['users_csv'].tempfile
	csv = CSV.read(file, :headers => true)
	csv.each do |row|
		@user = User.new
		@user.email = row['email']
		@user.first_name = row['first_name']
		@user.last_name = row['last_name']
		@user.password = row['password']
		@user.password_confirmation = row['password']
		@user.phone_num = row['phone_num']
		@user.class_size = row['class_size']
		@user.school_id = row['school_id']
		@user.is_active = true
		@user.role = params['create_users']['role']
		unless @user.save
			failed_emails.push(row['email'])
		end
	end
	if failed_emails.size > 0
		data = "All users added except for users with the following emails: "+failed_emails.join(", ")
		send_data( data, :filename => "failed_accounts.txt" )
	else
		redirect_to users_url
	end
  end

  def privacy
  end
end
