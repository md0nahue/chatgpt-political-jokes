require 'watir'
require 'webdrivers'
require 'pry'
require 'awesome_print'
require 'httparty'
require 'nokogiri'
require 'uri'

class Bing
  def initialize
    options = {
      args: [
        "--user-agent=#{custom_user_agent}",
        "--disable-blink-features=AutomationControlled",
        "--disable-infobars",
        "--headless"
      ]
    }

    @browser = Watir::Browser.new :chrome, options: options
    Signal.trap("INT") do
      puts "Exiting script and closing browser..."
      quit
      exit
    end
  end

  def quit
    @browser.quit
  end

  def pause
    sleep(rand(1.0..5.0))
  end

  def youtube_search(search)
    puts "youtube searching: #{search}"
    @browser.goto("https://videos.bing.com")
    pause
    search_field = @browser.text_field(id: 'sb_form_q')
    human_like_typing(search_field, "#{search} site:youtube.com")
    links = @browser.html.scan(/https:\/\/www\.youtube\.com\/watch\?v=[\w-]+/).uniq
    links
  end

  def human_like_typing(input_field, text_to_type)
    text_to_type.chars.each do |char|
      input_field.send_keys char
      sleep(rand(0.1..0.6))
    end

    sleep(rand(0.5..2.0))
    input_field.send_keys :return
  end

  private

  def custom_user_agent
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
  end
end

# bing = Bing.new

# begin
#   bing.youtube_search("funny cats")
# ensure
#   bing.quit
# end