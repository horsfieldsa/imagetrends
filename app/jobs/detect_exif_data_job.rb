class DetectExifDataJob
    include SuckerPunch::Job

    require 'exifr/jpeg'
  
    def perform(image_id)
        begin
            detection_logger.info("Attempting to detect EXIF data for Image: #{image_id}")
            @image = Image.find(image_id)

            # TODO: Better handling of base url.
            file = "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(@image.image_image, only_path: true)

            download = open(file)
            IO.copy_stream(download, '/tmp/image.jpg')

            has_exif = EXIFR::JPEG.new('/tmp/image.jpg').exif
            
            if has_exif
                model = EXIFR::JPEG.new('/tmp/image.jpg').model
                detection_logger.info("EXIF data for Image: #{image_id} Model: #{model}")

                @tag = Tag.new
                @tag.name = "Camera: #{model ? model : "Not Detected"}"
                @tag.source = "Extract EXIF Data"
                @tag.image = @image
                @tag.save
            else
                @tag = Tag.new
                @tag.name = "No EXIF Data"
                @tag.source = "Extract EXIF Data"
                @tag.image = @image
                @tag.save
                detection_logger.info("Image does not have EXIF data, Image: #{image_id}")
            end

            rescue StandardError => e
                puts(e)
                @tag = Tag.new
                @tag.name = "Error - Extract EXIF Data"
                @tag.source = "Extract EXIF Data"
                @tag.image = @image
                @tag.save
                detection_logger.error("Error detecting EXIF data for Image: #{image_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end