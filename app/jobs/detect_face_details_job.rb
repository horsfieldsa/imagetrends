class DetectFaceDetailsJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
            detection_logger.info("Attempting to detect face details for image #{sneaker_id}")
            @sneaker = Sneaker.find(sneaker_id)

            client = Aws::Rekognition::Client.new
            resp = client.detect_faces({
                    image: { bytes: @sneaker.sneaker_image.download }
            })

            resp.face_details.each do |label|
                puts "#{label.name}"

                @tag = Tag.new
                @tag.name = label.name
                @tag.sneaker = @sneaker
                @tag.save

                detection_logger.info("Face details detected for #{sneaker_id}: #{@tag.name}")

            end
            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.error("Error detecting face details for image: #{sneaker_id} - #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end