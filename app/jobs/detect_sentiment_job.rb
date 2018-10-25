class DetectSentimentJob
    include SuckerPunch::Job
  
    def perform(comment_id)
        begin

            detection_logger.info("Attempting to detect sentiment for Comment: #{comment_id}")
            @comment = Comment.find(comment_id)

            config = {
                logger: xray_logger
              }
                           
            XRay.recorder.configure(config)

            segment = XRay.recorder.begin_segment 'imagetrends'

            XRay.recorder.capture('detect_sentiment', segment: segment) do |subsegment|

                job_annotations = { 
                    comment_id: @comment.id,
                    image_id: @comment.image.id,
                    user_name: @comment.user.username,
                    user_id: @comment.user.id
                }
                subsegment.annotations.update job_annotations

                client = Aws::Comprehend::Client.new
                resp = client.detect_sentiment({
                    text: @comment.comment,
                    language_code: "en",
                  })

                if resp.sentiment 
                    detection_logger.info("Detected sentiment for Comment: #{comment_id} Details: #{resp.sentiment}")
                    @comment.sentiment = resp.sentiment
                    @comment.save    
                else
                    @comment.sentiment = "UNKNOWN"
                    @comment.save
                    detection_logger.info("No sentiment detected for Comment: #{comment_id} Details: #{resp}")
                end

            end

            XRay.recorder.end_segment

            rescue StandardError => e
                puts(e)
                @comment.sentiment = "ERROR"
                @comment.save
                detection_logger.error("Error detecting sentiment for Comment: #{comment_id} Details: #{e}")
        end
    end

    def detection_logger
        @@detection_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

    def xray_logger
        @@xray_logger ||= Logger.new("#{Rails.root}/log/xray.log")
    end

end