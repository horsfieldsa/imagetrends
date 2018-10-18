class DetectFaceDetailsJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            @sneaker = Sneaker.find(sneaker_id)

            client = Aws::Rekognition::Client.new
            resp = client.detect_faces({
                    image: { bytes: @sneaker.sneaker_image.download }
            })

            if resp.face_details.count == 0 
                detection_logger.info("No face details detected for Image: #{sneaker_id}")
            else
                detection_logger.info("Face Details: #{resp.face_details}")      
            end

            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.error("Error detecting face labels for Image: #{sneaker_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end