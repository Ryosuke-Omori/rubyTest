#!/usr/bin/ruby

require 'date'
require 'active_support/time'

# 現在の日付取得
date_today = Date.today
str_today = date_today.strftime("%Y-%m-%d")
p str_today

# 日時をDate型に変換
def custom_parse(str)
    date = nil
    if str && !str.empty? #railsなら、if str.present? を使う
        begin
            date = DateTime.parse(str).to_s
            # parseで処理しきれない場合
            rescue ArgumentError
            formats = ['%Y:%m:%d %H:%M:%S'] # 他の形式が必要になったら、この配列に追加
            formats.each do |format|
                begin
                date = DateTime.strptime(str, format)
                break
                rescue ArgumentError
                end
            end
        end
    end
    return date
end
str_atime = "2005-06-05T09:47:31+09:00"
date_atime = custom_parse(str_atime)
p "------"
p str_atime
p date_atime

p "------"
timezone_jpn = "+09:00"
str_time = "#{str_today}T08:25#{timezone_jpn}"
# str_time = "2018-10-09T08:25+09:00"
p str_time
date_time = custom_parse(str_time)
p date_time

p "======================="

now = Time.now
p now

str_now_date = now.strftime("%Y-%m-%d")
p str_now_date
str_now_time = now.strftime("%Y-%m-%d %H:%M:%S")
p str_now_time

p (now - 1.hour).strftime("%Y-%m-%dT%H:%M:%S")
