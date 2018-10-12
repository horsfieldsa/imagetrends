class DetectLabelsJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            detection_logger.info("Attempting to detect labels for image #{sneaker_id}")
            @sneaker = Sneaker.find(sneaker_id)

            client = Aws::Rekognition::Client.new
            resp = client.detect_labels({
                    image: { bytes: @sneaker.sneaker_image.download }, 
                    max_labels: 20, 
                    min_confidence: 50,
            })

            resp.labels.each do |label|
                puts "#{label.name}-#{label.confidence.to_i}"

                @tag = Tag.new
                @tag.name = label.name
                @tag.confidence = label.confidence
                @tag.source = "Rekognition - Detect Labels"
                @tag.sneaker = @sneaker
                @tag.save

                detection_logger.info("Label detected for #{sneaker_id}: #{@tag.name}")

            end
            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.error("Error detecting labels for image: #{sneaker_id} - #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end