require 'fileutils'
require 'pry'

class CombineAudio
  def self.combine(input_folder, output_file)
    # Change to the input folder
    # Dir.chdir(input_folder)

    # Get all MP3 files in the folder
    mp3_files = Dir.glob("#{input_folder}/*.mp3").sort_by { |f| f[/\d+/].to_i }

    # Create a temporary text file listing all the MP3 files
    file_list = "file_list.txt"
    File.open(file_list, 'w') do |file|
      mp3_files.each do |mp3|
        file.puts("file '#{File.expand_path(mp3)}'")
      end
    end

    # Run ffmpeg to concatenate the MP3 files
    ffmpeg_command = "ffmpeg -f concat -safe 0 -i #{file_list} -c copy #{output_file}"
    system(ffmpeg_command)

    # Clean up the temporary file
    File.delete(file_list)

    puts "MP3 files have been combined into #{output_file}"
  end
end
# # Define the folder containing the MP3 files and the output file
# input_folder = "./data"
# output_file = "combined_output.mp3"

