class DetectCelebritiesJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            detection_logger.info("Attempting to detect celebrities for Image: #{sneaker_id}")
            @sneaker = Sneaker.find(sneaker_id)

            config = {
                logger: xray_logger
              }  
              
            XRay.recorder.configure(config)

            segment = XRay.recorder.begin_segment 'imagetrends'
            XRay.recorder.capture('detect_celebrities', segment: segment) do |subsegment|

                job_annotations = { 
                    image_id: @sneaker.id,
                    user_name: @sneaker.user.username,
                    user_id: @sneaker.user.id
                }
                subsegment.annotations.update job_annotations

                client = Aws::Rekognition::Client.new
                resp = client.recognize_celebrities({
                        image: { bytes: @sneaker.sneaker_image.download }
                })

                if resp.celebrity_faces.count == 0 
                    detection_logger.info("No celebrieties detected for Image: #{sneaker_id}")
                end

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

            end

            XRay.recorder.end_segment

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

    def xray_logger
        @@xray_logger ||= Logger.new("#{Rails.root}/log/xray.log")
    end

end