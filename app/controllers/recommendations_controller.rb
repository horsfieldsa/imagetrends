class RecommendationsController < ApplicationController

  # GET /recommendations
  def index
    @recommended = get_recommendations(current_user.id)
  end

  def user_recommendations
    @recommended = get_recommendations(current_user.id)
    render partial: "recommended"
  end

  def useritem_recommendations
    @recommended = get_recommendations(current_user.id)
    render partial: "recommended"
  end

  private

  def get_recommendations(user_id)

    collection = []
    recommendations = []

    uri = URI("#{ENV["RECOMMEND_API"]}?user_id=#{user_id}")
    recommendations_logger.info("Recommendation API: #{uri}")
 
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      response = http.request request # Net::HTTPResponse object
      recommendations_logger.info("Recommendation API Response: #{response.body.to_json}")

      recommendations = JSON.parse(response.body)
    end 

    recommendations_logger.info("Recommendations: #{recommendations}")

    recommendations.first(4).each do |recommendation|
      suppress(Exception) do
        collection <<  Image.find(recommendation['itemId'])
      end
    end

    recommendations_logger.info("Recommendations Collection: #{collection}")

    return collection
  end

  def recommendations_logger
    @@recommendations_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end
