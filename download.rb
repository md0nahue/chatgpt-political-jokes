require 'open3'
require 'json'
require 'pry'

class Download
  attr_reader :download_successful

  def parse_formats(json_data)
    formats = []
    json_data.each do |format|
      id = format['format_id']
      ext = format['ext']
      resolution = format['resolution'] || ''
      protocol = format['protocol']
      width, height = resolution.split('x').map(&:to_i)

      next unless width && height
      unless protocol.include?('THROTTLED') || width <= height
        formats << {
          id: id,
          ext: ext,
          resolution: resolution,
          width: width,
          height: height,
          codec: format['vcodec'] || 'unknown'
        }
      end
    end
    formats
  end

  # Get the highest quality non-throttled format that matches the required codec and resolution
  def get_best_format(formats, preferred_codec='avc1', preferred_resolution='1280x720')
    formats.select { |f| f[:codec].downcase.start_with?(preferred_codec) && f[:resolution] == preferred_resolution }.max_by { |f| f[:width] * f[:height] }
  end

  def initialize(video_url, output_filename, duration)
    @download_successful = false
    # Use youtube-dlp to get format data
    format_command = "yt-dlp -J #{video_url}"
    json_data = nil

    Open3.popen3(format_command) do |stdin, stdout, stderr, wait_thr|
      output = stdout.read
      json_data = JSON.parse(output)['formats']
      @video_duration = JSON.parse(output)['duration'].to_f
    end

    formats = parse_formats(json_data)
    best_format = get_best_format(formats)

    if best_format
      puts "Selected format: #{best_format[:id]}, Resolution: #{best_format[:resolution]}, Extension: #{best_format[:ext]}, Codec: #{best_format[:codec]}"
      best_format_id = best_format[:id]
      file_extension = best_format[:ext]

      # Calculate a random start time for the clip
      max_start_time = @video_duration - duration
      start_time = rand(0..max_start_time).round

      # Use youtube-dlp to download a random clip of the specified duration
      download_command = <<-CMD
        yt-dlp -f #{best_format_id} --download-sections "*#{start_time}-#{start_time + duration}" -o "#{output_filename}" #{video_url}
      CMD

      puts "Running command: #{download_command.strip}"
      Open3.popen3(download_command.strip) do |stdin, stdout, stderr, wait_thr|
        puts stdout.read
        puts stderr.read
      end
      @download_successful = true
    else
      puts "No suitable format found with codec avc1 and resolution 1280x720."
    end
  end
end

# Example usage:
# Pass the video URL, desired output filename (without extension), and the duration in seconds
# downloader = Download.new('https://www.youtube.com/watch?v=Cad4evnfKhs', 'output_video', 10)
# puts "Download successful: #{downloader.download_successful}"