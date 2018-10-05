#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'

doc = Nokogiri.HTML(open("https://225225.jp/9ns/news.php"))

# ページに含まれるリンクを出力する
doc.css('#body > ul.news2 > li').each do |element|
  element.children.each do |child|
    if child.name == "span"
        puts child.content
    end
    if child.name == "a"
        puts child[:href]
        puts child.content
    end
  end
  puts "---"
end