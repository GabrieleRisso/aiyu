Open.ai Gpt-Based text generation meets Google gTTS and Mozzilla TTS voice generation with improved audio quality and timestamp accuracy using forced alignment.
Fast Whisper transcript generation, powerful text to text translation, Stable Diffusion text to image and much more.


|    	| c    	| t    	| a    	| s    	| tr   	|   	|
|----	|------	|------	|------	|------	|------	|---	|
| c  	| c2c  	| c2t  	| c2a  	|  /   	| c2tr 	|   	|
| t  	| t2c  	| t2t  	| t2a  	| t2s  	| t2tr 	|   	|
| a  	| a2c  	| a2t  	| a2a  	| a2s  	| a2tr 	|   	|
| s  	|  /   	| s2t  	| s2a  	| s2s  	| s2tr 	|   	|
| tr 	| tr2c 	| tr2t 	| tr2a 	| tr2s 	|  ?   	|   	|


What is it ￼
This repository aims to fill the momentary void of usable interconnect products in the AI sphere by providing a set of powerful functions and resources for creating interconnected, AI-powered products. As the field of artificial intelligence continues to advance, many new and innovative technologies are being developed. However, there is currently a lack of cohesive, integrated systems that allow these technologies to work together seamlessly. That's where gptX comes in.

Sell pipelines are an essential piece of interconnected products in the AI sphere due to their simplicity, power, and well-documented nature. These pipelines allow for quick and easy processing of data, enabling AI systems to ingest, manipulate, and transform large amounts of data in real-time. 

One of the key advantages of multi-platform shell pipelines is their simplicity. These pipelines can be easily customized and adjusted to fit the specific needs of an AI system. Additionally, they require minimal coding and can be developed using basic shell scripts, making them accessible to a wide range of users regardless of their background or technical knowledge.

features:
hackable
chat-gpt talk with voice (text2speaker) -> t2sk
chat-gpt talk to file (text2audio) -> p2a = p2t && t2a
gtts multilingual text support (text2text) p2a= 
gtts multilingual voice support (text2audio)
ai-voice quality enhancement (audio2audio)
ai-voice to subtiles (audio+text2subtitles) 
coincise pipelines (input2output)
CPU focus on performance
documented
hackable 

In the terminal:

export OPENAI_API_KEY="your key string here"

Shell function are not inherinenlty executable, load them first:

'''. t2s'''

usage:

t2s "Who is Lain? and what is a this serial exeriments story all about"


the name tells what the funtion does.




Copyright © 2023 Gabriele Risso
