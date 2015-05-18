require 'rubygems'
require 'bundler/setup'

require 'active_support/all'
require 'highline/import'
require 'pathname'

# Defaults
output_path = "/media/Ad Hoc"
preset = "iPad"

puts "So you wanna convert videos, eh?"
puts "---"

video_paths = []

loop do
  video_path = ask("Path to video? (blank for no more)")

  break if video_path.blank?

  video_paths << video_path
end

videos_count = video_paths.count

puts "Ok! So we have #{videos_count} videos!"

output_path = ask("Output path? ") { |q| q.default = output_path }
preset = ask("Preset? ") { |q| q.default = preset }

video_paths.each do |path|
  pathname = Pathname.new(path) 
  basename = pathname.basename(".*")
  command = %Q{HandBrakeCLI --preset "#{preset}" \--input "#{path}" \--output "#{output_path}/#{basename}.mp4"}

  puts "Converting #{path}..."

  `#{command}`

  puts "Finished #{path}!"
end

puts "Woohoo!"
