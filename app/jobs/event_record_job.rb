class EventRecordJob
  include SuckerPunch::Job

  def perform(event)
    record_logger.info("Recording Event: #{event}")
    record_logger.info("Event (JSON): #{event.to_json}")

    segment = XRay.recorder.begin_segment 'imagetrends'
    XRay.recorder.capture('record_event') do |subsegment|

      uri = URI(ENV["EVENT_RECORD_API"])
      header = {
        'Content-Type': 'application/json'
        }

      record_logger.info("Request URI: #{uri.to_json}")
      record_logger.info("Request URI Host: #{uri.host}")
      record_logger.info("Request URI Port: #{uri.port}")
      record_logger.info("Request PATH: #{uri.request_uri}")
      record_logger.info("Request HEADER: #{header}")

      # Create the HTTP objects
      https = Net::HTTP.new(uri.hostname, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri, header)
      request.body = event.to_json

      record_logger.info("Request DETAIL: #{request.to_json}")
      record_logger.info("Request BODY: #{request.body.to_json}")

      # Send the request
      response = https.request(request)
      
      record_logger.info("Request RESPONSE: #{response.to_json}")
      record_logger.info("Request RESPONSE Message: #{response.message.to_json}")

    end

    XRay.recorder.end_segment

    rescue StandardError => e
      puts(e)
      record_logger.error("Error Recording Event: #{e}")
  end

  private

  def record_logger
    @@record_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end