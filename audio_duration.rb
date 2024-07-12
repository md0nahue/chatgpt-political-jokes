require 'fileutils'
require 'pry'
require 'json'

class AudioDuration
  # AudioDuration.get_mp3_duration(file_path)
  def self.get_mp3_duration(file_path)
    # Run ffprobe command and capture the output in JSON format
    ffprobe_command = "ffprobe -v quiet -print_format json -show_format -show_streams \"#{file_path}\""
    output = `#{ffprobe_command}`

    # Parse the JSON output
    json_output = JSON.parse(output)
    puts json_output
    # Extract the duration from the format section
    duration = json_output['format']['duration']
    
    puts duration.to_f # Convert duration to float and return
    duration.to_f
  end

  def self.get_all_mp3_durations(input_folder)
    # Change to the input folder
    # Dir.chdir(input_folder)

    # Get all MP3 files in the folder
    mp3_files = Dir.glob("./#{input_folder}/*.mp3").sort_by { |f| f[/\d+/].to_i }

    mp3_files.map do |mp3|
      get_mp3_duration(File.expand_path(mp3))
    end
  end
end
  # Define the folder containing the MP3 files and the output file
