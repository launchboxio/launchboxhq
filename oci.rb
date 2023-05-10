require 'docker'

puts Docker.info

artifact = ARGV[0]

image = Docker::Image.create('fromImage' => artifact)
# puts image.GraphDriver
filepath = image.json['GraphDriver']['Data']['UpperDir']

file = File.open("#{filepath}/package.yaml")
puts file