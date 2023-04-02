## Core shell functions for AI

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
v --> video
sk -> speaker
```
</details>

|     | t text    | a audio |
|---- |------ |------ |
| t   | `t2t`   | `t2a`   |
| a   | `a2t`   | `a2a`   |

|    	| c    	| t    	| a    	| s    	|  i 	|  tr 	|
|----	|------	|------	|------	|------	|------	|---	|
| c  	| c2c  	| c2t  	| c2a  	|  c2s   	| c2i 	| c2tr 	|
| t  	| `t2c`  	| `t2t`  	| `t2a`  	| t2s 	| `t2i` 	| `t2tr`  	|
| a  	| a2c  	| `a2t`  	| `a2a`  	| `a2s`  	| a2i 	|  a2tr 	|
| s  	|  c2s   	| s2t  	| s2a  	| s2s  	| s2i 	|  s2tr 	|
| i 	| i2c 	| i2t 	| i2a 	| i2s 	|  `i2i`  	|  i2tr 	|

Current state of implemented functions

## What is **AIyu**:

In essence, the Aiyu Shell pipelines serve as the interweaving adhesive that binds the various AI components together - a technological superglue of sorts!


## Features:

 * **Hackable**
 * It support most languages
 * **Linux** and **Mac** compatible. Windows is coming soon.
 * Beautiful [Charm](https://charm.sh/ "Charm") **TUI interface** written in Go.
 * Terminal editor and **Markdown reader**.
 * CPU focus on **performance**
 * Documented (very soon)
<details>

<summary>Concise pipelines (inputs2output)</summary>
 
 🔹 Ask gpt and gtts answer to **speaker** (text2speaker) -> t2sk <br /> 
 🔹 Ask gpt and gtts answer to **audio** (text2audio) -> t2a  <br />
 🔹 Ask gpt and produce specifically **code** (code2text) -> c2t  <br />
 🔹 Take audio and produce text **transcript** (audio2text) -> a2t  <br />
 🔹 Take audio and produce **subtitles** transcript (audio2subtitles) -> a2s  <br />
 🔹 Prompt gpt and produce text (prompt2text) -> p2t  <br />
 🔹 Take text and translate into text (text2text) -> t2tr  <br />
 🔹 Take audio and **enhance quality** into audio (audio2audio) -> a2a  <br />
 🔹 Take audio & text transcript and produce subtitles (audio+text2subtitles) -> at2s  <br />
 🔹 Take text and stable diffusion produce **image** (text2image) -> t2i  <br />


 
</details>

### Screenshots & Tutorial: [Wiki](https://github.com/GabrieleRisso/aiyu/edit/main/wiki.md "Aiyu Wiki")

 <p align="left"> <a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FGabrieleRisso%2Faiyu&count_bg=%234D4244&title_bg=%23EA2424&icon_color=%233E3636&title=aiyu+&edge_flat=false"/></a> </p>


## In the terminal:

###### download directory and enter it:
```
git clone https://github.com/GabrieleRisso/aiyu.git 
cd aiyu/
```
###### set the key to global scope: 
```
export OPENAI_API_KEY="your key string here"
```
###### load a function:
```
. t2s
```
###### use it like this:
```
t2a "Who is Lain?"
```

### AIyu pipeline (WIP)

example: suppose **question.mp3** is a file containing a question in english  
```
a2t question.mp3 && t2tr it && t2a
```
This turns the audio question into English text, translates it in Italian, then ask the question in Italian to gpt3.5 and produce Italian audio answer.

Every function always looks for newly created inputs in /dev/shm/ if not explicitly specified.

##### Dependencies

They are prompted if missing and a link to install them is provided. Functions mostly leverages Python libs installed via pip and pre-build Docker images. Memory usage statistics will be out soon.


##### Who's project is doing the AI heavy lifting? 

 * [shell-gpt](https://github.com/TheR1D/shell_gpt "text-to-text")
 * [gtts](https://gtts.readthedocs.io/en/latest/index.html "text-to-speach")
 * [aeneas](https://github.com/readbeyond/aeneas "subtitles")
 * [translate-shell](https://github.com/soimort/translate-shell "translate")
 * [whisper-c2translate](https://github.com/jordimas/whisper-ctranslate2 "audio-to-text")
 * [mtts](https://github.com/mozilla/TTS "text-to-vocie")
 * [rnnnoise](https://github.com/GregorR/rnnoise-models "noise filter")
 * [stable-diffusion](https://github.com/fboulnois/stable-diffusion-docker "image gen")


### Open for collaboartions; let's make **aiyu** awesome toghter
 
 * .env global
 * per-command tuning
 * wiki documentation 
 * compose functions to make new ones
 * suggestions are desired!

### Leave a star if you like this

### Citation
If you utilize this reposistory please consider citing it with:

```
@misc{aiyu,
  author = {Gabriele Risso},
  title = {aiyu: core shell functions for andvanced ai},
  year = {2023},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/gabrielerisso/aiyu}},
}
```


### Copyright

Copyright © 2023 Gabriele Risso. 
