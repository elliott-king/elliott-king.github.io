# for sending the request
require "uri"
require "net/http"
require "json"

# for loading our environment variables
require "dotenv/load"

# for scraping our blog
require "open-uri"
require "nokogiri"

root = "https://elliott-king.github.io"
page = "/2020/10/medium_api_images/"
doc = Nokogiri::HTML(URI.open(root + page))
# article =  doc.css('article')[0].to_s
article =  doc.css('article')[0]
article.css('[src^="/"]').each do |i|
    i["src"] = root + i["src"]
end

article.css('[href^="/"]').each do |i|
    i["href"] = root + i["href"]
end

url = URI("https://api.medium.com/v1/users/#{ENV["USER_ID"]}/posts")

https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Authorization"] = "Bearer #{ENV["AUTH_TOKEN"]}"
request["Content-Type"] = "application/json"
body = {
  title: "Debugging Medium Images",
  content: article,
  contentFormat: "html",
  tags: ["javascript", "medium", "API", "debugging"],
  publishStatus: "draft",
  canonicalUrl: root + page,
}
request.body = body.to_json

response = https.request(request)
puts response.read_body