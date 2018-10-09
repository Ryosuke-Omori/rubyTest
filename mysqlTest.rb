#!/usr/bin/ruby

require 'mysql2'
require 'yaml'

config = YAML.load_file("config.yml")
client = Mysql2::Client.new(
  :host => config["mysql"]["host"],
  :username => ENV[config["mysql"]["username"]],
  :password => ENV[config["mysql"]["password"]],
  :database => config["mysql"]["database"]
  )

# INSERT
# esc_time = client.escape()
esc_title = client.escape('time3')
esc_url = client.escape('https://www.google.co.jp/')
p esc_title
p esc_url
insert_query = "INSERT INTO news (`id`, `time`, `title`, `url`, `created_at`, `updated_at`) VALUES (NULL, '2018-10-09T08:25', '#{esc_title}', '#{esc_url}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
client.query(insert_query)

# SELECT
client.query("SELECT * FROM news").each do |news|
  puts "-------------"
  news.each do |key, value|
    puts "#{key} => #{value}"
  end
end