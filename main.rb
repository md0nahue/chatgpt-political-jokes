require './polly'
require './combine_audio'
require './bing'
require './download'
require './audio_duration'
require './video_clipper'
# Must change script and search strings!

script = [
"Cliff, you won’t believe this! Police just busted a massive Lego theft ring at Brick Builders in Eugene.",
"A Lego theft ring? What is this, the Toy Story version of Ocean's Eleven? Were they trying to build a criminal empire brick by brick?",
"It gets crazier. The owner, Ammon Henrikson, was buying new, unopened Lego sets that had been stolen from local stores.",
"So he’s the Kingpin of Lego Land? I bet his evil lair was built with 4,153 stolen sets. 'Quick, to the Batcave! But first, step on these Legos and cry!'",
"Exactly. Suspects would steal hundreds of dollars’ worth of Legos and sell them to Henrikson for cash, usually at a fraction of the retail value.",
"Right, because there’s nothing more inconspicuous than selling hot Legos. 'Hey buddy, wanna buy some Death Star kits? Limited edition, no questions asked!'",
"Many of the suspects were using the money to buy drugs. The SPD worked with loss prevention investigators from Target, Fred Meyer, Barnes & Noble, and Walmart.",
"They needed a whole task force for this? Imagine the briefing: 'Okay team, today we're up against the Lego Mafia. Watch out for booby traps and those tiny, painful pieces.'",
"During the search, police recovered over $200,000 worth of Legos.",
"Two hundred grand in Legos? That’s a lot of plastic bricks! At this rate, kids are gonna need a black market dealer just to finish their Millennium Falcon.",
"Chief Andrew Shearer said that organized retail theft impacts everyone by increasing the cost of items we buy for our families.",
"Great, so my grocery bill is higher because some guy is flipping Legos like they’re rare Pokémon cards? 'Sorry kids, no ice cream tonight, someone stole all the Ninjago sets.'",
"Henrikson, 47, was arrested and charged with organized retail theft and theft by receiving.",
"47 years old and running a Lego theft ring? That’s a midlife crisis I didn’t see coming. Forget sports cars, he’s out here trying to recreate the Taj Mahal in his basement.",
"Albert Nash, 57, from Eugene, was also arrested and charged with the same crimes.",
"Two middle-aged guys running a Lego racket? Who’s next, Grandma’s illegal Beanie Baby smuggling ring? 'Come on, Grandma, hand over the Princess Diana bears!'"
]


search_strings = [
"Lego theft news report",
"Police raid toy store",
"Funny Lego stop motion animation",
"Lego crime scene parody"
]

script_name = "lego"
name = script_name

combined_audio_file = "/Users/magnusfremont/Desktop/dailyshow/#{name}/combined.mp3"
combined_video_file = "/Users/magnusfremont/Desktop/dailyshow/#{name}/combined.mp4"

unless Dir.exist?(script_name)
  Dir.mkdir(script_name)
end

FileUtils.mkdir_p("#{script_name}/audio")
FileUtils.mkdir_p("#{script_name}/video")

speaker = "Joanna"
counter = 0
script.each do |text|
  response = Polly.speak(text, speaker, counter, script_name)
  # puts response
  puts speaker
  if speaker == "Joanna"
    speaker = "Brian"
  else
    speaker = "Joanna"
  end

  counter = counter + 1
end

if File.exist?(combined_audio_file)
  File.delete(combined_audio_file)
end

CombineAudio.combine("/Users/magnusfremont/Desktop/dailyshow/#{name}/audio",
                    combined_audio_file)

# binding.pry
video_length = AudioDuration.get_mp3_duration(combined_audio_file)
# video_count = Dir.glob(File.join("/Users/magnusfremont/Desktop/dailyshow/#{name}/video", '*')).select { |file| File.file?(file) }.count

video_count = search_strings.count

clip_duration = (video_length / video_count.to_f).round + 1

bing = Bing.new
  search_strings.each_with_index do |search, idx|
  output_file = "/Users/magnusfremont/Desktop/dailyshow/#{name}/video/#{idx}.mp4"
  if File.exist?(output_file)
    puts "File #{output_file} already exists. Skipping..."
    next
  end

  repeat = true
  links = bing.youtube_search(search)
  while repeat
    link = links.first(10).sample
    puts link

    downloader = Download.new(link, output_file, clip_duration)
    if downloader.download_successful && File.exist?(output_file)
      repeat = false
    else
      puts "failed to download correct video type, retrying"
    end
  end
end

if File.exist?(combined_video_file)
  File.delete(combined_video_file)
end

clipper = VideoClipper.new("/Users/magnusfremont/Desktop/dailyshow/#{name}/video", combined_video_file)
clipper.process_videos

# combine mp4 and mp3

def combine_video_audio(video_path, audio_path, output_path)
  ffmpeg_command = "ffmpeg -i #{video_path} -i #{audio_path} -c:v copy -c:a aac -strict experimental #{output_path}"
  puts "Running command: #{ffmpeg_command}"
  system(ffmpeg_command)
end

if File.exist?("/Users/magnusfremont/Desktop/dailyshow/#{name}/video_with_audio.mp4")
  File.delete("/Users/magnusfremont/Desktop/dailyshow/#{name}/video_with_audio.mp4")
end

combine_video_audio(combined_audio_file, combined_video_file, "/Users/magnusfremont/Desktop/dailyshow/#{name}/video_with_audio.mp4")

# add spacer time between spoken lines?
# add puppets








