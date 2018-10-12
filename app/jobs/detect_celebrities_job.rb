class DetectCelebritiesJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            detection_logger.info("Attempting to detect celebrities for Image #{sneaker_id}")
            @sneaker = Sneaker.find(sneaker_id)

            client = Aws::Rekognition::Client.new
            resp = client.recognize_celebrities({
                    image: { bytes: @sneaker.sneaker_image.download }
            })

            resp.celebrity_faces.each do |label|
                puts "#{label.name}-#{label.match_confidence.to_i}"

                @tag = Tag.new
                @tag.name = label.name
                @tag.confidence = label.match_confidence
                @tag.source = "Rekognition - Recognize Celebrities"
                @tag.sneaker = @sneaker
                @tag.save

                detection_logger.info("Celebrity detected for Image: #{sneaker_id} Name: #{@tag.name} Confidence: #{@tag.confidence}")

            end
            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.source = "Rekognition - Recognize Celebrities"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.error("Error detecting celebrities for Image: #{sneaker_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end