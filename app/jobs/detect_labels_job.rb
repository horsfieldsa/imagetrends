class DetectLabelsJob
    include SuckerPunch::Job
    require 'aws-xray-sdk'
  
    def perform(sneaker_id)

        user_config = {
            name: 'imagetrends',
            context_missing: 'LOG_ERROR',
            patch: %I[net_http aws_sdk]
          }
          
        XRay.recorder.configure(user_config)

        segment = XRay.recorder.begin_segment 'imagetrends'

        annotations = {
            image: sneaker_id
          }
          
        segment.annotations.update annotations

        XRay.recorder.capture('detect_labels', segment: segment) do |subsegment|

            begin

                detection_logger.info("Attempting to detect labels for Image #{sneaker_id}")
                @sneaker = Sneaker.find(sneaker_id)

                client = Aws::Rekognition::Client.new
                resp = client.detect_labels({
                        image: { bytes: @sneaker.sneaker_image.download }, 
                        max_labels: 20, 
                        min_confidence: 50,
                })

                if resp.labels.count == 0 
                    detection_logger.info("No labels detected for Image: #{sneaker_id}")
                end

                resp.labels.each do |label|
                    puts "#{label.name}-#{label.confidence.to_i}"

                    @tag = Tag.new
                    @tag.name = label.name
                    @tag.confidence = label.confidence
                    @tag.source = "Rekognition - Detect Labels"
                    @tag.sneaker = @sneaker
                    @tag.save

                    detection_logger.info("Label detected for Image: #{sneaker_id} Name: #{@tag.name} Confidence: #{@tag.confidence}")

                end
                rescue StandardError => e
                    puts("--------------------------------- [ERROR] ---------------------------------")
                    puts(e)
                    @tag = Tag.new
                    @tag.name = "Error"
                    @tag.source = "Rekognition - Detect Labels"
                    @tag.sneaker = @sneaker
                    @tag.save
                    detection_logger.error("Error detecting labels for Image: #{sneaker_id} Details: #{e}")

            end

            XRay.recorder.end_segment
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end