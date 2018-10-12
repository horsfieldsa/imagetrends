class DetectTextJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            detection_logger.info("Attempting to detect text for Image #{sneaker_id}")
            @sneaker = Sneaker.find(sneaker_id)

            client = Aws::Rekognition::Client.new
            resp = client.detect_text({
                    image: { bytes: @sneaker.sneaker_image.download }
            })

            resp.text_detections.each do |label|

                puts "#{label.detected_text}-#{label.confidence.to_i}"

                if label.confidence.to_i > 80 && label.type == "WORD"
                    @tag = Tag.new
                    @tag.name = label.detected_text
                    @tag.confidence = label.confidence
                    @tag.source = "Rekognition - Detect Text"
                    @tag.sneaker = @sneaker
                    @tag.save

                    detection_logger.info("Text detected in Image: #{sneaker_id} Text: #{@tag.name} Confidence: #{@tag.confidence}")
                end

            end
            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.source = "Rekognition - Detect Text"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.error("Error detecting text for Image: #{sneaker_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end