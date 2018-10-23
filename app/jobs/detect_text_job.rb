class DetectTextJob
    include SuckerPunch::Job
  
    def perform(image_id)
        begin
            detection_logger.info("Attempting to detect text for Image: #{image_id}")
            @image = Image.find(image_id)

            config = {
                logger: xray_logger
              }
              
            XRay.recorder.configure(config)

            segment = XRay.recorder.begin_segment 'imagetrends'
            XRay.recorder.capture('detect_text', segment: segment) do |subsegment|

                job_annotations = { 
                    image_id: @image.id,
                    user_name: @image.user.username,
                    user_id: @image.user.id
                }
                subsegment.annotations.update job_annotations

                client = Aws::Rekognition::Client.new
                resp = client.detect_text({
                        image: { bytes: @image.image_image.download }
                })

                if resp.text_detections.count == 0 
                    detection_logger.info("No text detected for Image: #{image_id}")
                end              

                resp.text_detections.each do |label|

                    puts "#{label.detected_text}-#{label.confidence.to_i}"

                    if label.confidence.to_i > 80 && label.type == "WORD"
                        @tag = Tag.new
                        @tag.name = label.detected_text
                        @tag.confidence = label.confidence
                        @tag.source = "Rekognition - Detect Text"
                        @tag.image = @image
                        @tag.save

                        detection_logger.info("Text detected in Image: #{image_id} Text: #{@tag.name} Confidence: #{@tag.confidence}")
                    end
                    
                end
            end

            XRay.recorder.end_segment

            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.source = "Rekognition - Detect Text"
                @tag.image = @image
                @tag.save
                detection_logger.error("Error detecting text for Image: #{image_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

    def xray_logger
        @@xray_logger ||= Logger.new("#{Rails.root}/log/xray.log")
    end

end