require 'rubygems'
require 'bundler/setup'

require 'yaml'
require 'pathname'
require 'pty'
require 'highline/import'

config = YAML.load_file('clutch.yml')

video_paths = config['video_paths']
output_path = config['output_path']
output_extension = config['output_extension']
preset = config['preset']

videos_count = video_paths.count

puts "Ok! So we have #{videos_count} videos which will be converted to .#{output_extension} using the #{preset} preset! The converted videos will then be found in #{output_path}!"
puts "\n"

video_paths.each do |path|
  puts path
end

puts "\n"

permission = ask("Let's get ready to vroom vroom? (y/n) ") { |q| q.validate = /y|n/ }

video_paths.each do |path|
  pathname = Pathname.new(path) 
  basename = pathname.basename(".*")
  command = %Q{HandBrakeCLI --preset "#{preset}" \--input "#{path}" \--output "#{output_path}/#{basename}.#{output_extension}"}

  puts "Converting #{path}..."

  system(command)

  puts "Finished #{path}!"
end

puts "Woohoo!"
