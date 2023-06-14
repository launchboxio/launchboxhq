require 'docker'
require 'yaml'

puts Docker.info

artifact = ARGV[0]

image = Docker::Image.create('fromImage' => artifact)
# puts image.GraphDriver
filepath = image.json['GraphDriver']['Data']['UpperDir']

file = File.read("#{filepath}/package.yaml")
puts file
obj = YAML.load(file)
