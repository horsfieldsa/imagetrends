class DetectLabelsJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
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

                if label.name == 'Footwear' && label.confidence > 75
                    @sneaker.approved = true
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