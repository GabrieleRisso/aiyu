
lang=${lang:-$(echo ${LANG:0:2})};

filter=filter.rnn && wget -qO $filter https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn

session=${session:-$(echo "$(wget -qO - http://frightanic.com/goodies_content/docker-names.php)-$(date '+%Y-%m-%d-%H')" )};




audiogw="/dev/shm/audiogw_$session.mp3"
voicegw="/dev/shm/voicegw_$session.mp3"
textgw="/dev/shm/textgw_$session.txt"
tradw="/dev/shm/tradw_$session.txt"
subgw="/dev/shm/subgw_$session.srt"


voiceg="/dev/shm/vocieg_$session.mp3"
audiog="/dev/shm/audiogg_$session.mp3"
textg="/dev/shm/textgg_$session.txt"
askg="/dev/shm/askgg_$session.txt"
subg="/dev/shm/subgg_$session.srt"
input=""
output=""
tmp=""


if ! type t22s 2>/dev/null 1>&2;
then
    t22s ()
	{

	    if ! command -v docker --version 2>/dev/null 1>&2;
	    then
            echo " Gum docker is not installed on your system. Install it: https://docs.docker.com/engine/install and re-try" >&2;
            echo "o-sgpt is disabled" >&2;
        elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
            echo "o-sgpt is disabled" >&2;
        else
		    if ! type o-sgpt 2>/dev/null 1>&2;
            then
		        o-sgpt ()
                {     
                
				
				local input="$1";
				#takes function "textg" parmaeter as input or if empty prompts for input
                local input=${input:-$(echo $(gum input --char-limit=4000 --placeholder="Type something here, just askg me!" --width="$(($COLUMNS-5))" --header="I'm an AI, use me wisely!" --header.italic --header.border="rounded" --header.foreground="50" ) )};
                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
                
                echo $input > $askg > /dev/null ;

                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Docker to interact with sgpt..." --\
                docker run --rm --env OPENAI_API_KEY -v gpt-cache:/tmp/shell_gpt ghcr.io/ther1d/shell_gpt --no-animation --chat "$session" "$input" > "$textg";
                gum confirm --negative="no" --affirmative="yes, let's read " "open pager to read subgtitles?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 140" && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < o-sgpt.log ;
                

                local output=$(cat $textg | tr -d '\n');

                if [ -z "$output" ];
                then
                    echo '{{ Bold "Open.ai servers are probably down or unreachable, try again...}}' | gum format -t template >&2;
                    return 1;
                fi
				
				
			    gum style "INPUT: saved at $askg" "$input" "OUTPUT: saved at $textg" "$output" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
                gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read output?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $textg; 
                echo '{{ Bold "[+] sgpt OK" }}' | gum format -t template >&2;
                
				}
				
				
		    else
                echo '{{ Color "50" "0" " o-sgpt is set on the system." }}' | gum format -t template >&2;
            fi
        fi


		if ! command -v mtts-cli --version 2>/dev/null 1>&2;
		then
            echo '{{  Color "99" "0" " tts is not intalled on your system, please install it: pip install TTS and re-try" }}' | gum format -t template >&2;
            echo "o-mtts is disabled" >&2;
        else
		    if ! type o-mtts 2>/dev/null 1>&2;
            then
		        o-mtts ()
                {
				
				vocoder=${vocoder:-$(echo "vocoder_models/universal/libri-tts/wavegrad")}
				model=${model:-$(echo "tts_models/uk/mai/glow-tts")}
				
                local input="$1";
                [ -f $textg ] && local input=${input:-$(echo $textg)} || local input=${input:-$(echo $(gum file $PWD))};

                local output="$2";
     			local output=$voiceg;

                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
                #desc
         	    gum style "using mtts for voiceg generation." "INPUT: saved at $input" "OUTPUT: audiog saved at $voiceg" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";                

                #spinner + mtts command
                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using mtts to transform textg to audiog..." --\
                
								
				tts --text "$input" \
    --model_name "$model" \
    --vocoder_name "$vocoder" \
    --out_path $output
				
				mtts-cli -l ${lang} -f $textg --output $output;
			    echo '{{ Bold "[+] mtts OK" }}' | gum format -t template >&2;
		        }
		    else
                echo '{{ Bold "o-mtts is set on the system" }}' | gum format -t template >&2;
            fi
        fi

		if ! command -v ffmpeg --version 2>/dev/null 1>&2;
		then
            echo "ffmpeg is not installed on your system.  Install it and re-try" >&2;
            echo "o-ffmpeg is disabled" >&2;
        else
		    if ! type o-ffmpeg 2>/dev/null 1>&2;
            then
		        o-ffmpeg ()
                {
                local input="$1";
                local input=$voiceg;
                local output="$2";
                local output=$audiog;
                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi

                gum style "using ffmpeg for audiog enanchemnt and output creation." "INPUT: audiog saved at $input" "OUTPUT: audiog saved at $output" "FILTER: audiog filter at $filter" "SESSION: $session" "SPEED: 1.4" "VOLUME: 1.3" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";                

            	ffmpeg -y -i $input -loglevel quiet -af "atempo=1.4,dialoguenhance,arnndn=m=$filter,volume=1.3" $output;
			    echo '{{ Bold "[+] ffmpeg OK" }}' | gum format -t template >&2;

		        }
		    else
                echo '{{ Bold "o-ffmpeg is set on the system" }}' | gum format -t template >&2;
            fi
        fi

		if ! command -v play --version 2>/dev/null 1>&2;
		then
            echo '{{  Color "99" "0" " play is not intalled on your system, please install it and re-try" }}' | gum format -t template >&2;
            echo "o-play is disabled" >&2;
        else
		    if ! type o-play 2>/dev/null 1>&2;
            then
		        o-play ()
                {
                local input=$audiog;
                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
		
                gum style "using play soX for audiog output." "INPUT: audiog saved at $input" "OUTPUT: audiog to speaker" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";

                play $input >/dev/null;
			    echo '{{ Bold "[+] paly OK" }}' | gum format -t template >&2;

		        }
		    else
                echo '{{ Bold " o-play is set on the system" }}' | gum format -t template >&2;
            fi
        fi

		o-sgpt && o-mtts && o-ffmpeg && o-play $audiog;
		echo '{{ Bold "DONE! what now?" }}' | gum format -t template >&2;
		
		CHOICE=$(gum choose --item.foreground 250 "edit function sourcecode" "edit output text in glow" "play output audio" "help" "contribute to aiyu");

		[[ "$CHOICE" == "edit function sourcecode" ]] && $EDITOR $(gum filter --value="${FUNCNAME[0]}" --height=9);
		[[ "$CHOICE" == "edit output text in glow" ]] && cp $textg "${textg::-4}.md" && glow "/dev/shm/";
		[[ "$CHOICE" == "play output audio" ]] && ffplay -nodisp -autoexit -loglevel fatal $voiceg;
		[[ "$CHOICE" == "help" ]] && glow -p README.md;
		[[ "$CHOICE" == "contribute to aiyu" ]] && echo "Great! I thought so, thank you for making $(gum style --bold "aiyu") is the best! leave a $(gum style --bold "star") if you like this. Go to: https://github.com/GabrieleRisso/aiyu";
	}
else
    echo '{{ Bold "o-t2s is set on the system" }}' | gum format -t template >&2;
    exit 1;
fi



		o-sgpt && o-mtts && o-ffmpeg && o-play $audiog;
	}
else
    echo '{{ Bold "o-t2s is set on the system" }}' | gum format -t template >&2;
fi
