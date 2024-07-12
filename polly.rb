require 'aws-sdk-polly'
require 'json'
require 'pry'

class Polly
  def self.speak(text, speaker, idx, name)

    puts text
    polly = Aws::Polly::Client.new(region: 'us-west-2') # Use your preferred region

    unless Dir.exist?(name)
      Dir.mkdir(name)
    end

    output_file = "./#{name}/audio/#{idx}.mp3"
    if File.exist?(output_file)
      puts "File #{output_file} already exists. Skipping..."
      return
    end
    # speech_marks_file = "./#{name}/#{idx}_marks.json"

    # Call the synthesize_speech method for the audio
    audio_response = polly.synthesize_speech({
      engine: "neural",
      output_format: 'mp3',  # Can be 'json', 'mp3', 'ogg_vorbis', or 'pcm'
      text: text,
      text_type: 'text',     # Specify the text type as SSML
      voice_id: speaker,    # Choose a voice
    })

    # Save the audio to a file
    File.open(output_file, 'wb') do |file|
      file.write(audio_response.audio_stream.read)
    end

    # # Call the synthesize_speech method for the speech marks
    # marks_response = polly.synthesize_speech({
    #   engine: "neural",
    #   output_format: 'json',  # Get the speech marks as JSON
    #   text: text,
    #   text_type: 'text',     # Specify the text type as SSML
    #   voice_id: speaker,    # Choose a voice
    #   speech_mark_types: ['word']  # Request word-level speech marks
    # })

    # # Save the speech marks to a file
    # File.open(speech_marks_file, 'wb') do |file|
    #   file.write(marks_response.audio_stream.read)
    # end

    # # Parse the speech marks JSON
    # speech_marks = []
    # File.open(speech_marks_file, 'r') do |file|
    #   file.each_line do |line|
    #     speech_marks << JSON.parse(line)
    #   end
    # end

    # # Return both the audio file and the speech marks as JSON
    # {
    #   audio_file: output_file,
    #   speech_marks: speech_marks
    # }
  end
end




