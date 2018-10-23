class DetectCelebritiesJob
    include SuckerPunch::Job
  
    def perform(image_id)
        begin
            detection_logger.info("Attempting to detect celebrities for Image: #{image_id}")
            @image = Image.find(image_id)

            config = {
                logger: xray_logger
              }  
              
            XRay.recorder.configure(config)

            segment = XRay.recorder.begin_segment 'imagetrends'
            XRay.recorder.capture('detect_celebrities', segment: segment) do |subsegment|

                job_annotations = { 
                    image_id: @image.id,
                    user_name: @image.user.username,
                    user_id: @image.user.id
                }
                subsegment.annotations.update job_annotations

                client = Aws::Rekognition::Client.new
                resp = client.recognize_celebrities({
                        image: { bytes: @image.image_image.download }
                })

                if resp.celebrity_faces.count == 0 
                    detection_logger.info("No celebrieties detected for Image: #{image_id}")
                end

                resp.celebrity_faces.each do |label|
                    puts "#{label.name}-#{label.match_confidence.to_i}"

                    @tag = Tag.new
                    @tag.name = label.name
                    @tag.confidence = label.match_confidence
                    @tag.source = "Rekognition - Recognize Celebrities"
                    @tag.image = @image
                    @tag.save

                    detection_logger.info("Celebrity detected for Image: #{image_id} Name: #{@tag.name} Confidence: #{@tag.confidence}")

                end

            end

            XRay.recorder.end_segment

            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.source = "Rekognition - Recognize Celebrities"
                @tag.image = @image
                @tag.save
                detection_logger.error("Error detecting celebrities for Image: #{image_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

    def xray_logger
        @@xray_logger ||= Logger.new("#{Rails.root}/log/xray.log")
    end

end