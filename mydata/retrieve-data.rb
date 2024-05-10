require 'http'
require 'nokogiri'
require 'debug'
require 'json'
require 'hugging_face'

MODS = 'http://www.loc.gov/mods/v3'

client = HuggingFace::InferenceApi.new(api_token: ENV['HUGGING_FACE_API_TOKEN'])
puts "[\n"
File.readlines('druids.csv', chomp: true).each do |druid|
  data = HTTP.get("https://purl.stanford.edu/#{druid.delete_prefix('druid:')}.xml")

  ng_xml = Nokogiri(data.body.to_s)
  title =  ng_xml.xpath('//identityMetadata/objectLabel').first.content
  abstract =  ng_xml.xpath('//mods:abstract', mods: MODS).first.content
  vector = client.embedding(input: [abstract]).first

  puts JSON.dump({title:,abstract:,vector:}) + ","
end
puts "]"
