# chatgpt-political-jokes

## background

I have been experimenting recently with using ffmpeg, ruby, AWS Polly TTS, web crawling with watir, and youtube-dlp in order to programmatically create videos meant to be published on youtube.

https://www.youtube.com/watch?v=XuuT3Xspd_U
https://www.youtube.com/watch?v=2reFQiRv4kk

My inspiration for this project were videos on youtube like this one, which are just montages of posts on Reddit. These videos are similar enough that it seems like creating them would be very easy simply using a script.

https://www.youtube.com/watch?v=k-lQDRigpQI

## Creating the Daily Show with ChatGPT

For this project, I was attempting to create political commentary and humor similar to the Daily Show.

This particular script requires require authenticating AWS Polly using an AWS IAM credential, installing ffmpeg and youtube-dlp, and other gems listed in the script files. 

Step #1 choose a news article. Copy-paste the article into ChatGPT along with this prompt:

  >Given this article, write a dialogue between two characters
>
> Jenny will give a serious summary of the news article

>Cliff will make hilarious, funny, witty, outrageous, irreverent interjections about what Jenny is saying, poking fun at current events and public figures

>  The spoken text can be as long as possible - really linger over the source text and make the most of it. Focus on the funniest jokes, and make sure that the observational humor is really the very best that you can make it. Try to make jokes which are closer to the subject matter, rather than non sequiturs. 
>
> Do not include any stage direction like (Laughs) or (chortles)
>
> response should be an array of strings of the spoken lines, do not include speaker like "Cliff: dfsf"
>
 > Try to channel the humor of Chris Rock/Jerry Seinfeld

Step #2 (use same ChatGPT context as previous prompt)

> I want you to suggest nine video clips that will be the background images of the dialogue. They will play sequentially. Must be easily searchable on youtube. Must be returned as an array >of strings. Must be simple search strings for youtube that are likely to return a hit.
>  Give the youtube search strings as an array of strings
>
>You can change the number of video clips depending on how long the script was.
>
>Copy-paste the results of these two ChatGPT prompts into main.rb, along with a title for the video.

main.rb will then:

* Create mp3s for the provided script using AWS Polly
* Combine those MP3s
* Download youtube clips for the background of the video
* Combine the youtube clips
* Apply the dialogue to the video

## Future Improvements

For future improvements, I hope to add
-animated figures for each "speaker"


Now, I struggled to find an audience for this kind of content. So I think that it would be better to repurpose some of the methods here so that it would instead create videos which were a RESPONSE to a specific youtube video - content about viral youtube creators is more likely to get clicks than content about news which does not come from an accredited news outlet. 

For this change, I would hope to use youtube-dlp to download the transcript of the target music video, maybe play a few short clips before the commentary, and then also display still clips from the target youtube video in the background of the "puppet show".

Thanks for reading this far! I hope that this project has highlighted my creativity and software engineering acumen enough for you to consider me joining your team!
