class DetectModerationLabelsJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            @sneaker = Sneaker.find(sneaker_id)

            client = Aws::Rekognition::Client.new
            resp = client.detect_moderation_labels({
                    image: { bytes: @sneaker.sneaker_image.download }, 
                    min_confidence: 75,
            })

            resp.moderation_labels.each do |label|
                puts "#{label.name}-#{label.confidence.to_i}"

                @tag = Tag.new
                @tag.name = label.name
                @tag.sneaker = @sneaker
                @tag.confidence = label.confidence
                @tag.source = "Rekognition - Detect Moderation Labels"               
                @tag.save

                if label.name == 'Suggestive' && label.confidence > 80
                    @sneaker.approved = false
                    @sneaker.save
                end

            end
            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.sneaker = @sneaker
                @tag.save
        end
    end

end