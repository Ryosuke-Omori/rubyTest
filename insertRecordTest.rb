#!/usr/bin/ruby

require 'mysql2'
require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'active_support/time'

config = YAML.load_file("config.yml")
client = Mysql2::Client.new(
  :host => config["mysql"]["host"],
  :username => ENV[config["mysql"]["username"]],
  :password => ENV[config["mysql"]["password"]],
  :database => config["mysql"]["database"]
  )

doc = Nokogiri.HTML(open(config["target"]))

time_now = Time.now                                     # 現在日時
str_today = time_now.strftime("%Y-%m-%d")               # 現在日付部分文字列
time_before = time_now - 1.day                          # 現在日時から1日前
str_before = time_before.strftime("%Y-%m-%dT%H:%M:%S")  # 現在日時から1日前の文字列

doc.css('#body > ul.news2 > li').each do |element|
  topic = { time: "", href: "", content: "" }
  element.children.each do |child|
    if child.name == "span"
      topic[:time] = client.escape("#{str_today}T#{child.content}")
    end
    if child.name == "a"
      topic[:href] = client.escape(child[:href])
      topic[:content] = client.escape(child.content)
    end
  end
  search_query = <<-EOS
SELECT
  *
FROM
  news
WHERE
  `time` > '#{str_before}' AND
  url = '#{topic[:href]}'
  EOS
  result = client.query(search_query)
  if result.size == 0
    insert_query = <<-EOS
INSERT INTO
  news (
    `id`,
    `time`,
    `title`,
    `url`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    NULL,
    '#{topic[:time]}',
    '#{topic[:content]}',
    '#{topic[:href]}',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  )
    EOS
    client.query(insert_query)
  end
end