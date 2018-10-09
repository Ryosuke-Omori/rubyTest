#!/usr/bin/ruby

require 'yaml'

config = YAML.load_file("config.yml")

p config
p "-----"

database = config["mysql"]["database"]
p database
p "-----"

username = config["mysql"]["username"]
puts ENV[username]
password = config["mysql"]["password"]
puts ENV[password]
p "-----"

test_address = config["mysql"]["test_address"]
p test_address