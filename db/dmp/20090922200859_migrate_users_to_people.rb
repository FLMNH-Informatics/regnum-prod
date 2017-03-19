class MigrateUsersToPeople < ActiveRecord::Migration
  def self.up
    Person.delete_all

    User.find(:all).each do |user|
      @person = Person.create!(:first_name => user.first_name,
        :last_name => user.last_name,
        :created_at => user.created_at,
        :updated_at => user.updated_at,
        :office_address_line_one => user.address_line1,
        :office_address_line_two => user.address_line2,
        :office_city => user.city,
        :office_state => user.state,
        :office_zip => user.zipcode,
        :initials => user.initials,
         :country => user.country,
         :fax => user.fax,
         :phone => user.phone,
         :institution => user.institution
      )
      user.people_id = @person.id
      user.save!
    end
  end
  def self.down
    Person.delete_all
  end
end
 # "login" character varying,
  #email character varying,
  #created_at date NOT NULL DEFAULT now(),
  #updated_at date,
  #remember_token character varying,
  #remember_token_expires_at date,
  #crypted_password character varying(40) NOT NULL,
  #salt character varying(40),
  #activation_code character varying,
  #enabled boolean DEFAULT false,
  #"password" character varying,
 #initials character varying,
