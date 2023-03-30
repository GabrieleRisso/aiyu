lang=${lang:-$(echo ${LANG:0:2})};

filter=filter.rnn && wget -qO $filter https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn

session=${session:-$(echo "$(wget -qO - http://frightanic.com/goodies_content/docker-names.php)-$(date '+%Y-%m-%d-%H')" )};

export OPENAI_API_KEY="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"



audiow="/dev/shm/audiow_$session.mp3"
voicew="/dev/shm/voicew_$session.mp3"
textw="/dev/shm/textw_$session.txt"
tradw="/dev/shm/tradw_$session.txt"
subw="/dev/shm/subw_$session.srt"
codew="/dev/shm/codew_$session.txt"


voiceg="/dev/shm/vocieg_$session.mp3"
audiog="/dev/shm/audiog_$session.mp3"
textg="/dev/shm/textg_$session.txt"
askg="/dev/shm/askg_$session.txt"
tradg="/dev/shm/tradg_$session.txt"
codeg="/dev/shm/codeg_$session.txt"

subg="/dev/shm/subg_$session.srt"
input=""
output=""
tmp=""

if ! type t2c 2>/dev/null 1>&2;
then
    t2c ()
	{
	
	
	if ! command -v docker --version 2>/dev/null 1>&2;
	    then
            echo " Gum docker is not installed on your system. Install it: https://docs.docker.com/engine/install and re-try" >&2;
            echo "o-sgpc is disabled" >&2;
        elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
            echo "o-sgpc is disabled" >&2;
        else
		    if ! type o-sgpc 2>/dev/null 1>&2;
            then
		        o-sgpc ()
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

                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Docker to interact with sgpc..." --\
                docker run --rm --env OPENAI_API_KEY -v gpt-cache:/tmp/shell_gpt ghcr.io/ther1d/shell_gpt --no-animation --code "$input" > "$codeg";
                gum confirm --negative="no" --affirmative="yes, let's read " "open pager to read subgtitles?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 140" && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < o-sgpt.log ;
                

                local output=$(cat $codeg | tr -d '\n');

                if [ -z "$output" ];
                then
                    echo '{{ Bold "Open.ai servers are probably down or unreachable, try again...}}' | gum format -t template >&2;
                    return 1;
                fi
				
				
			    gum style "INPUT: saved at $askg" "$input" "OUTPUT: saved at $codeg" "$output" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
                gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read output?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $codeg; 
                echo '{{ Bold "[+] sgpc OK" }}' | gum format -t template >&2;
                
				}
				
				
		    else
                echo '{{ Color "50" "0" " o-sgpc is set on the system." }}' | gum format -t template >&2;
            fi
        fi
	

		o-sgpc "$1";
	}
else
    echo '{{ Bold "t2c is set on the system" }}' | gum format -t template >&2;
fi