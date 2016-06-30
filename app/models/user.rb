class User < ActiveRecord::Base
  include Mail
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :current_password

  enum type: %w(sydkikee sydkiker)

  before_save { self.email = email.downcase }
  before_save { self.distributed_email = distributed_email.downcase if distributed_email }


  validates :name, length: { maximum: 50 }, presence: true, unless: :admin?
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: SydKik::VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, unless: :admin?
  validate :email_has_valid_domain, unless: :admin?
  validates :phone, length: { maximum: 20 }, format: { with: SydKik::VALID_PHONE_REGEX }, unless: :admin?
  validates :zip, length: { maximum: 10 }, format: { with: SydKik::VALID_ZIP_REGEX }, unless: :admin?

  scope :admin, -> { where "admin = ?", true }

  def email_has_valid_domain
    domain = Address.new(email).domain.try(:downcase)
    tld = domain.try(:split, ".").try(:last).try(:upcase)
    errors.add(:email, "is not a valid email address") if TopLevelDomain.find_by_domain(tld).blank? || MisspelledDomain.find_by_domain(domain).present?
  end

  def masked_password
    mp = ""
    password.length.times { mp << "*" }
    mp
  end

  def self.random_password
    Devise.friendly_token[0, 12]
  end

  def resolve_location
    zipcode = Zipcode.find_by_zip(zip) if zip
    return unless zipcode
    lat = zipcode.lat.to_f
    long = zipcode.long.to_f
    [lat, long]
  end

  def access_token
    User.create_access_token(self)
  end

  ##
  # Get a user from a token
  def self.read_access_token(signature)
    id = verifier.verify(signature)
    User.find_by_id id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  def self.create_access_token(user)
    verifier.generate(user.id)
  end

  def self.verifier
    ActiveSupport::MessageVerifier.new(Rails.application.secrets[:secret_key_base])
  end
end
