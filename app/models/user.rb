class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  attr_accessor :password

  has_many :submissions, foreign_key: "submitted_by"
  belongs_to :role
  has_and_belongs_to_many :ontologies
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_uniqueness_of :email

  before_create lambda{ self.enabled = false ; self.role_id = 2 }
  before_save :encrypt_password

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email,password)
    user = User.find_by_email(email)

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) && user.enabled == true
      user.last_login = Time.now
      user.save
      user
    else
      nil
    end
  end

  def self.has_email? email
    User.where(email: email).count != 0
  end

  #TODO need to change Role.role_id to Role.rank for clarity sake User.role_id = Role.id Role.role_id is really a ranking
  def is_a_reviewer?; ['reviewer','reviewer_opt_in', 'reviewer_opt_out'].index(self.role.name) != nil end

  def is_admin?; self.role.role_id == Role.find_by_name('admin').role_id end

  def is_editor?; self.role.role_id == Role.find_by_name('reviewer').role_id end 
  alias_method :is_reviewer?, :is_editor?

  def is_opt_in_reviewer?; ( self.role.role_id == Role.find_by_name('reviewer_opt_in').role_id ) end

  def is_opt_out_reviewer?; ( self.role.role_id == Role.find_by_name('reviewer_opt_out').role_id ) end
  
  def is_user?; self.role.role_id == Role.find_by_name('user').role_id end

  def self.admin_user_emails
    ["chrisdell@gmail.com", "ncellinese@ufl.edu"]
  end
  
end
