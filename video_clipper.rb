require 'fileutils'

class VideoClipper
  def initialize(folder_path, output_filename)
    @folder_path = folder_path
    @output_filename = output_filename
    @temp_clips = []
  end

  def process_videos
    video_files = Dir.entries(@folder_path).select { |f| f =~ /^\d+\.mp4$/ }.sort_by { |f| f.to_i }

    video_files.each do |video_file|
      video_path = File.join(@folder_path, video_file)
      process_video(video_path)
    end

    combine_clips
  ensure
    cleanup_temp_clips
  end

  private

  def process_video(video_path)
    temp_clip = File.join(@folder_path, "temp_clip_#{SecureRandom.uuid}.mp4")
    @temp_clips << temp_clip

    ffmpeg_command = "ffmpeg -i #{video_path} -an -c copy #{temp_clip}"
    puts "Running command: #{ffmpeg_command}"
    system(ffmpeg_command)
  end

  def combine_clips
    return if @temp_clips.empty?

    file_list = File.join(@folder_path, 'temp_clips.txt')
    File.open(file_list, 'w') do |file|
      @temp_clips.each { |clip| file.puts("file '#{clip}'") }
    end

    ffmpeg_command = "ffmpeg -f concat -safe 0 -i #{file_list} -c copy -an #{@output_filename}"
    puts "Running command: #{ffmpeg_command}"
    system(ffmpeg_command)

    File.delete(file_list)
  end

  def cleanup_temp_clips
    @temp_clips.each { |clip| File.delete(clip) if File.exist?(clip) }
  end
end

# # Example usage:
# # Replace 'path/to/your/folder' with the path to your folder containing the video files.
# # Replace 'output.mp4' with the desired output filename.
# folder_path = 'path/to/your/folder'
# output_filename = 'output.mp4'

# clipper = VideoClipper.new(folder_path, output_filename)
# clipper.process_videos