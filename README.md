# Shell functions for AI

**Open.ai** Gpt-3.5turbo text generation meets **Google** gTTS and **Mozzilla** TTS audio generation. Featuers improved audio quality using ffmpeg RNN noise supression filter and subtitle timestamp accuracy using **Aeneas** forced alignment.
Fast **Whisper** ctranslate2 transcript generation, Translate-shell text to text translation, **Stable Diffusion** text to image and much more.

<details>

<summary>Glossary of abbreviations</summary>

## Inputs and Outputs

```c  -> code
t  -> text
a  -> audio
s  -> subtitle
tr -> translation
i  -> image
sk -> speaker
```
</details>

|    	| c    	| t    	| a    	| s    	|  tr  	|   	|
|----	|------	|------	|------	|------	|------	|---	|
| c  	| c2c  	| c2t  	| c2a  	|  /   	| c2tr 	|   	|
| t  	| `t2c`  	| `t2t`  	| `t2a`  	| t2s 	| `t2tr` 	|   	|
| a  	| a2c  	| `a2t`  	| `a2a`  	| `a2s`  	| a2tr 	|   	|
| s  	|  /   	| s2t  	| s2a  	| s2s  	| s2tr 	|   	|
| tr 	| tr2c 	| tr2t 	| tr2a 	| tr2s 	|  ?   	|   	|

With some algebra we can cover most of those.

## What is it:

This repository aims to fill the momentary void of usable interconnect products in the AI sphere by providing a set of powerful functions and resources for creating interconnected, AI-powered products. 
There is currently a lack of cohesive, integrated systems that allow these technologies to work together seamlessly. That's where **aiyu** comes in.

Shell pipelines are an essential piece of interconnected products in the AI sphere due to their simplicity, power, and hopefully well-documented nature. Aiyu pipelines allow for quick and easy processing of data, enabling AI systems to ingest, manipulate, and transform large amounts of data in real-time. 

## Features:

 * Hackable
 * it support most languages
 * Linux and Mac compatible. Windows is coming soon.
 * Beautiful [Charm](https://charm.sh/ "Charm") TUI interface written in Go.
 * Terminal editor and Markdown reader.
 * Ask gpt and gtts answer to speaker (text2speaker) -> t2sk
 * Ask gpt and gtts answer to audio (text2audio) -> t2a
 * Ask gpt and produce specifically code (code2text) -> c2t
 * Take audio and produce text transcript (audio2text) -> a2t
 * Take audio and produce subtitles transcript (audio2subtitles) -> a2s
 * Prompt gpt and produce text (prompt2text) -> p2t
 * Take text and translate into text (text2text) -> t2tr
 * Take audio and enhance quality into audio (audio2audio) -> a2a
 * Take audio & text transcript and produce subtitles (audio+text2subtitles) -> at2s
 * Take text and stable diffusion produce image (text2image) -> t2i
 * Concise pipelines (inputs2output)
 * CPU focus on performance
 * Documented (very soon)
 * Hackable again!

## In the terminal:

##### download directory and enter it:
```
git clone https://github.com/GabrieleRisso/aiyu.git 
cd aiyu/
```
##### set the key to global scope: 
```
export OPENAI_API_KEY="your key string here"
```
##### load a function:
```
. t2s
```
##### use it like this:
```
t2a "Who is Lain? and what is a this serial exepriments story all about?"
```

![alt text](https://github.com/gabrielerisso/aiyu/blob/main/t2a.jpg?raw=true)


Dependancies are prompted if missing and a link to install them is provided.
Functions mostly leverages **Gum**, **Python**, **Docker**.
Memory usage statistics will be out soon.

### Tutorial for functions:
[wiki](https://github.com/GabrieleRisso/aiyu/edit/main/wiki.md "Aiyu Wiki")


### I need your collaboartion to make **aiyu** awsome!
 
 * .env global
 * best for voice
 * code compression
 * code compilation
 * 
 * code revision
 * wiki documentation 
 * compose functions to make new ones
 * suggestions are desired!


### Copyright

Copyright © 2023 Gabriele Risso. 
