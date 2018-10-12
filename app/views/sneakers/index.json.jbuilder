json.array!(@sneakers) do |sneaker|
  json.extract! sneaker, :id, :image_url
  json.url sneaker_url(sneaker, format: :json)
end
