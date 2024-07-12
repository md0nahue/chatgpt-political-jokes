require 'ffmpeg'

class Animate
  def initialize(video_path, char1_img, char2_img, char1_timestamps, char2_timestamps)
    @video_path = video_path
    @char1_img = char1_img
    @char2_img = char2_img
    @char1_timestamps = char1_timestamps
    @char2_timestamps = char2_timestamps
  end

  # Function to create the waggle and bobbing animation filter
  def waggle_and_bob(start_time, end_time)
    duration = end_time - start_time
    "overlay=x='if(between(t,#{start_time},#{end_time}),10+sin(2*PI*(t-#{start_time})/2)*10, NAN)':y='if(between(t,#{start_time},#{end_time}),H-h-10+cos(2*PI*(t-#{start_time})/2)*5, NAN)':enable='between(t,#{start_time},#{end_time})'"
  end

  # Function to generate the filter complex string with animations
  def generate_filter_complex
    filter_complex = ""

    # Add filters for the first character with animations
    @char1_timestamps.each do |timestamp|
      start_time, end_time = timestamp
      filter_complex += "[0:v][1:v] #{waggle_and_bob(start_time, end_time)}, "
    end

    # Add filters for the second character with animations
    @char2_timestamps.each do |timestamp|
      start_time, end_time = timestamp
      filter_complex += "[0:v][2:v] #{waggle_and_bob(start_time, end_time)}, "
    end

    # Remove the trailing comma and space
    filter_complex.chomp!(', ')

    filter_complex
  end

  # Method to run the FFmpeg command to overlay the images with the generated filter complex
  def process_video(output_path)
    filter_complex = generate_filter_complex
    FFMPEG::Movie.new(@video_path).transcode(output_path, {custom: "-i #{@char1_img} -i #{@char2_img} -filter_complex \"#{filter_complex}\""})
    puts "Video processing complete. Check #{output_path}."
  end
end

# Example usage
video_path = 'path/to/your/video.mp4'
char1_img = 'path/to/char1.png'
char2_img = 'path/to/char2.png'
char1_timestamps = [
  [5, 10],   # Char1 appears from 5s to 10s
  [20, 25]   # Char1 appears from 20s to 25s
]
char2_timestamps = [
  [15, 20],  # Char2 appears from 15s to 20s
  [30, 35]   # Char2 appears from 30s to 35s
]

# Create an instance of the Animate class and process the video
animator = Animate.new(video_path, char1_img, char2_img, char1_timestamps, char2_timestamps)
animator.process_video('output_video.mp4')
