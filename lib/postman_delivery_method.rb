# :nocov:
##
# Extends the application module.
#
# NOTE: This module is loaded only at startup, so any modifications won't take
#       effect until Rails is restarted.
module SydKik
  ##
  # Define a custom delivery method that connects to postman rather than SMTP.
  class PostmanDeliveryMethod
    ##
    # Initialize the class.
    def initialize(_values)
      self.settings = {}
    end

    attr_accessor :settings

    ##
    # Override the deliver! method to send via postman.
    def deliver!(mail)
      # Rails.logger.debug "* * * * *"
      # Rails.logger.debug "PostmanDeliveryMethod::deliver! called, mail is (#{mail})"
      # Rails.logger.debug "* * * * *"

      apicredentials = ENV["SYDKIK_USERNAME"]
      apipassword = ENV["SYDKIK_PASSWORD"]

      sescredentials = ENV["SES_ACCESS_KEY"]
      sespassword = ENV["SES_SECRET_ACCESS_KEY"]

      send_params = {}
      # send_params["meta" = { "text_id" => textid, "campaign" => campaignname }
      send_params["headers"] = { "ST-Policy" => "strip", "X-rpcampaign" => format("sydkik%s", Time.zone.now.strftime("%Y%m%d")) }
      send_params["taxonomy"] = { "publisher" => "sydkik", "network" => "sydkik", "offer" => "sydkik" }
      send_params["link_wrap"] = { "base_url" => "http://e.#{SydKik::DOMAIN_NAME}" }
      send_params["suppressions"] = { "ignore_unsubs" => true, "ignore_bounces" => true, "ignore_geos" => true, "ignore_replies" => true, "ignore_complaints" => true }

      send_params["to_addr"] = mail.to.first
      send_params["to_name"] = mail.to.first
      send_params["from_addr"] = mail.from.first
      send_params["from_name"] = SydKik::DOMAIN_BRANDNAME
      send_params["subject"] = mail.subject
      send_params["html"] = mail.html_part ? mail.html_part.body.raw_source : mail.body.raw_source
      send_params["text"] = mail.text_part ? mail.text_part.body.raw_source : mail.body.raw_source
      send_params["send_api"] = { "mailer" => { "type" => "amazon", "region" => "us-east-1", "username" => sescredentials, "password" => sespassword } }
      send_params["ignore_forbidden_words"] = false
      #### send_params["external_unsubscribe_url"] = "http://www.sydkik.com/unsubscribe"
      #### send_params["meta"] = {"subject" => mail.subject}

      # Rails.logger.debug "* * * * *"
      # Rails.logger.debug "Params: #{send_params}"
      # Rails.logger.debug "* * * * *"

      uri = Rails.env.production? ? URI.parse("https://postman-ext.cogolo.net/send") : URI.parse("https://162.223.52.157/send")

      header = { "Content-Type" => "application/json" }

      # Create the HTTP objects
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = Rails.env.production? ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.basic_auth apicredentials, apipassword
      request.body = send_params.to_json

      response = http.request(request)

      # When an error occurs, log it, re-send it via SES, and send a copy to the system account
      if response.try(:code) != "200"
        Rails.logger.error "Postman failed! Response was Code: (#{response.code})\tMsg: (#{response.msg})\t Body: (#{response.body.strip}), send params were (#{send_params})"

        # Re-send via SES
        ses = Aws::SES::Client.new(region: "us-east-1")
        response = ses.send_email(
          destination: {
            to_addresses: [send_params["to_addr"]]
          },
          # TODO: The double-quotes around the friendly from seem are getting
          #       stripped out somewhere, but it doesn't seem to be causing
          #       any issues on the recipient's side...
          source: %("#{send_params['from_name']}" <#{send_params['from_addr']}>),
          message: {
            subject: {
              data: send_params["subject"],
              charset: "utf-8"
            },
            body: {
              text: {
                data: send_params["text"],
                charset: "utf-8"
              },
              html: {
                data: send_params["html"].sub(/{{.*}}/, ""),
                charset: "utf-8"
              }
            }
          }
        )

        # Send a copy to the system account
        send_params["to_addr"] = SydKik::ADMIN_EMAIL
        send_params["to_name"] = SydKik::ADMIN_EMAIL
        send_params["subject"] = "POSTMAN ERROR: #{mail.to.first} #{send_params['subject']}"

        request.body = send_params.to_json
        http.request(request)
      end

      response
    end
  end
end
# :nocov:
