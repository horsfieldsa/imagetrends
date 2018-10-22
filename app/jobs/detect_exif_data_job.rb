class DetectExifDataJob
    include SuckerPunch::Job

    require 'exifr/jpeg'
  
    def perform(sneaker_id)
        begin
            detection_logger.info("Attempting to detect EXIF data for Image: #{sneaker_id}")
            @sneaker = Sneaker.find(sneaker_id)

            file = "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(@sneaker.sneaker_image, only_path: true)

            download = open(file)
            IO.copy_stream(download, '/tmp/image.jpg')

            has_exif = EXIFR::JPEG.new('/tmp/image.jpg').exif
            
            if has_exif
                model = EXIFR::JPEG.new('/tmp/image.jpg').model
                detection_logger.info("EXIF data for Image: #{sneaker_id} Model: #{model}")

                @tag = Tag.new
                @tag.name = "Camera: #{model ? model : "Not Detected"}"
                @tag.source = "Extract EXIF Data"
                @tag.sneaker = @sneaker
                @tag.save
            else
                @tag = Tag.new
                @tag.name = "No EXIF Data"
                @tag.source = "Extract EXIF Data"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.info("Image does not have EXIF data, Image: #{sneaker_id}")
            end

            rescue StandardError => e
                puts("--------------------------------- [ERROR] ---------------------------------")
                puts(e)
                @tag = Tag.new
                @tag.name = "Error"
                @tag.source = "Extract EXIF Data"
                @tag.sneaker = @sneaker
                @tag.save
                detection_logger.error("Error detecting EXIF data for Image: #{sneaker_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end