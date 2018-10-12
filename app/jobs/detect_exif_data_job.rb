class DetectExifDataJob
    include SuckerPunch::Job

    require 'exifr/jpeg'
  
    def perform(sneaker_id)
        begin
            @sneaker = Sneaker.find(sneaker_id)

            file = "http://localhost:3000" + rails_blob_path(@sneaker.sneaker_image, disposition: "attachment")
            puts(file)

            model = EXIFR::JPEG.new(IO.read(file)).model

            puts(model)
            @tag = Tag.new
            @tag.name = model
            @tag.sneaker = @sneaker
            @tag.save

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