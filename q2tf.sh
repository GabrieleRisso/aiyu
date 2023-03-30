lang=${lang:-$(echo ${LANG:0:2})};

filter=filter.rnn && wget -qO $filter https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn

session=${session:-$(echo "$(wget -qO - http://frightanic.com/goodies_content/docker-names.php)-$(date '+%Y-%m-%d-%H')" )};




audiow="/dev/shm/audiow_$session.mp3"
voicew="/dev/shm/voicew_$session.mp3"
textw="/dev/shm/textw_$session.txt"
tradw="/dev/shm/tradw_$session.txt"
subw="/dev/shm/subw_$session.srt"


voiceg="/dev/shm/vocieg_$session.mp3"
audiog="/dev/shm/audiog_$session.mp3"
textg="/dev/shm/textg_$session.txt"
askg="/dev/shm/askg_$session.txt"
subg="/dev/shm/subg_$session.srt"
input=""
output=""
tmp=""

if ! type q2t 2>/dev/null 1>&2;
then
    q2t ()
	{
		
	    if ! command -v docker --version 2>/dev/null 1>&2;
	    then
            echo " Gum docker is not installed on your system. Install it: https://docs.docker.com/engine/install and re-try" >&2;
            echo "q2t-sgpt is disabled" >&2;
        elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
        else
		    if ! type q2t-sgpt 2>/dev/null 1>&2;
            then
				
				echo '{{ Bold "[*] language: '$lang' " }}' | gum format -t template >&2;
				echo '{{ Bold "[*] session: '$session' " }}' | gum format -t template >&2;

		        q2t-sgpt ()
                {
				
				
				echo '{{ Bold "[!] sgpt started" }}' | gum format -t template >&2;
				
				
				
				local input="$1";
                #takes function input or if empty askgs for inputs
                local input=${input:-$(echo $(gum input --char-limit=4000 --placeholder="Type something here, just askg me!" --width="$(($COLUMNS-5))" --header="I'm an AI use me wisely!" --header.italic --header.border="rounded" --header.foreground="50" ) )};
				
                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
                
                echo $input > $askg >&2;

                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Docker to interact with sgpt..." --\
                docker run --rm --env OPENAI_API_KEY -v gpt-cache:/tmp/shell_gpt ghcr.io/ther1d/shell_gpt --no-animation --chat "$session" "$input" > "$textg";
				
                local output=$(cat $textg | tr -d '\n')  >&2;

                if [ -z "$output" ];
                then
                    echo '{{ Bold "Open.ai servers are probably down or unreachable, try again...' | gum format -t template >&2;
                    return 1;
                fi		
				
			    gum style "INPUT: saved at $askg" "$input" "OUTPUT: saved at $textg" "$output" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
                gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read output?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $textg; 
                
				echo '{{ Bold "[+] sgpt OK" }}' | gum format -t template >&2;
				
				
								
				CHOICE=$(gum choose --item.foreground 250 "edit function sourcecode" "edit output text in glow" "edit input text in glow" "help" "contribute to aiyu");
				[[ "$CHOICE" == "edit function sourcecode" ]] && $EDITOR $(gum filter --value="q2t" --height=9);
				[[ "$CHOICE" == "edit output text in glow" ]] && cp $textg "${textw::-4}.md" && glow "/dev/shm/";
				[[ "$CHOICE" == "edit input text in glow" ]] && cp $textg "${textg::-4}.md" && glow "/dev/shm/";
				[[ "$CHOICE" == "help" ]] && glow -p README.md;
				[[ "$CHOICE" == "contribute to aiyu" ]] && echo "Great! I thought so, thank you for making $(gum style --bold "aiyu") is the best! leave a $(gum style --bold "star") if you like this. Go to: https://github.com/GabrieleRisso/aiyu";
				
				
                }
		    else
                echo '{{ Color "50" "0" " q2t-sgpt is set on the system." }}' | gum format -t template >&2;
            fi
        fi



		q2t-sgpt "$1";
	}
else
    echo '{{ Bold "q2t is set on the system" }}' | gum format -t template >&2;
fi
