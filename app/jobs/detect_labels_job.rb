class DetectLabelsJob
    include SuckerPunch::Job
  
    def perform(image_id)
        begin

            detection_logger.info("Attempting to detect labels for Image: #{image_id}")
            @image = Image.find(image_id)

            config = {
                logger: xray_logger
              }
                           
            XRay.recorder.configure(config)

            segment = XRay.recorder.begin_segment 'imagetrends'

            XRay.recorder.capture('detect_labels', segment: segment) do |subsegment|

                job_annotations = { 
                    image_id: @image.id,
                    user_name: @image.user.username,
                    user_id: @image.user.id
                }
                subsegment.annotations.update job_annotations

                client = Aws::Rekognition::Client.new
                resp = client.detect_labels({
                        image: { bytes: @image.image_image.download }, 
                        max_labels: 20, 
                        min_confidence: 50,
                })

                if resp.labels.count == 0 
                    detection_logger.info("No labels detected for Image: #{image_id}")
                end
    
                resp.labels.each do |label|    
                    @tag = Tag.new
                    @tag.name = label.name
                    @tag.confidence = label.confidence
                    @tag.source = "Rekognition - Detect Labels"
                    @tag.image = @image
                    @tag.save
    
                    detection_logger.info("Label detected for Image: #{image_id} Name: #{@tag.name} Confidence: #{@tag.confidence}")
    
                end

            end

            XRay.recorder.end_segment


            rescue StandardError => e
                puts(e)
                @tag = Tag.new
                @tag.name = "Error - Detect Labels"
                @tag.source = "Rekognition - Detect Labels"
                @tag.image = @image
                @tag.save
                detection_logger.error("Error detecting labels for Image: #{image_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

    def xray_logger
        @@xray_logger ||= Logger.new("#{Rails.root}/log/xray.log")
    end

end