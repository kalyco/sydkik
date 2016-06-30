##
# Site-wide constants.
module SydKik
  ##
  # :section: Externalize domain name and branding.
  ##

  ##
  # The domain name for the site.
  DOMAIN_NAME = "sydkik.com".freeze

  ##
  # The brand name for the site.
  DOMAIN_BRANDNAME = "Sydkik".freeze

  ##
  # The email address to which administrative requests (i.e. reviews needed)
  # will be sent.
  ADMIN_EMAIL = "admin@sydkik.com".freeze

  ##
  # The email address from which transctional emails will be sent.
  FROM_EMAIL = "email@e.sydkik.com".freeze

  ##
  # The domain from which emails are sent.
  FROM_DOMAIN = "e.sydkik.com".freeze

  ##
  # The email address to which support requests and user feedback will be sent.
  FEEDBACK_EMAIL = "support@sydkik.com".freeze

  ##
  # :section: Configuration for beagle server process
  ##
  BEAGLE_PORT = 8888

  BEAGLE_URI = "http://localhost:#{BEAGLE_PORT}/".freeze

  ##
  # Regex for validating email addresses.
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_EMAIL_REGEX_HTML5 = '[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+'.freeze

  ##
  # Regex for validating street addresses.
  VALID_STREET_REGEX = /\A([\w#.,' \-])+\z/

  ##
  # Regex for validating city names.
  VALID_CITY_REGEX = VALID_STREET_REGEX

  ##
  # Regex for validating state names.
  VALID_STATE_REGEX = /\A(?:(A[KLRZ]|C[AOT]|D[CE]|F[LM]|G[AU]|HI|I[ADLN]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY]))\z/
  VALID_STATE_REGEX_HTML5 = "(?:(A[KLRZ]|C[AOT]|D[CE]|F[LM]|G[AU]|HI|I[ADLN]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY]))".freeze

  ##
  # Regex for validating ZIP codes.
  VALID_ZIP_REGEX = /\A\d{5}((-|\s)?\d{4})?\z/
  VALID_ZIP_REGEX_HTML5 = '\d{5}((-|\s)?\d{4})?'.freeze

  ##
  # Regex for validating phone numbers.
  VALID_PHONE_REGEX = /\A(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*\z/

  ##
  # Regex for validating phone numbers in HTML5.
  VALID_PHONE_REGEX_HTML5 = '(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*'.freeze
end
