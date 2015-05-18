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

permission = ask("Vroom vroom? (y/n) ") { |q| q.validate = /y|n/ }

if permission == "n"
  puts "Come back when you're ready."
  exit
end

def puts_separator
  puts "-------------------------------------"
  puts "*************************************"
  puts "-------------------------------------"
end

video_paths.each_with_index do |path, i|
  job = "(#{i+1}/#{videos_count})" 

  pathname = Pathname.new(path) 
  basename = pathname.basename(".*")
  command = %Q{HandBrakeCLI --preset "#{preset}" \--input "#{path}" \--output "#{output_path}/#{basename}.#{output_extension}"}

  puts_separator
  puts "#{job} Converting #{path}..."
  puts_separator

  system(command)

  puts_separator
  puts "#{job} Finished #{path}!"
  puts_separator
end

puts "Woohoo!"
