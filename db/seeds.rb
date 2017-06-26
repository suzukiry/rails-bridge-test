# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..5).each do |number|
  Entry.create(post_type: 2, eng_word: 'eng_' + number.to_s, jpn_word: 'jpn_' + number.to_s, description: 'description' + number.to_s, youtube_url: 'youtube' + number.to_s + '@youtube.com',site_url: 'bridge_post' + number.to_s + '@bridge.com')
end

