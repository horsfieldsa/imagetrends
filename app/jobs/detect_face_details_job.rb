class DetectFaceDetailsJob
    include SuckerPunch::Job
  
    def perform(sneaker_id)
        begin
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