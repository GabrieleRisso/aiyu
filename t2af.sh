
lang=${lang:-$(echo ${LANG:0:2})};


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

#-s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Docker to interact with sgpt..." --\
 #--show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" 
 #foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1"
#--foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1

#ffmpeg
filter=filter.rnn && wget -qO $filter https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn
advanced-audiot="atempo=1.4,dialoguenhance,arnndn=m=$filter,volume=1.3"
COLUMNS

if ! type t2a 2>/dev/null 1>&2;
then
    t2a ()
	{
		
	    if ! command -v docker --version 2>/dev/null 1>&2;
	    then
            echo " Gum docker is not installed on your system. Install it: https://docs.docker.com/engine/install and re-try" >&2;
            echo "t2a-sgpt is disabled" >&2;
        elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
            echo "t2a-sgpt is disabled" >&2;
        else
		    if ! type t2a-sgpt 2>/dev/null 1>&2;
            then
				
				echo '{{ Bold "[*] language: '$lang' change with: lang="eng" " }}' | gum format -t template >&2;
				echo '{{ Bold "[*] session: '$session' " }}' | gum format -t template >&2;

		        t2a-sgpt ()
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


				#-------------------------------------x
                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Docker to interact with sgpt..." --\
                docker run --rm --env OPENAI_API_KEY -v gpt-cache:/tmp/shell_gpt ghcr.io/ther1d/shell_gpt --no-animation --chat "$session" "$input" > "$textg";
				
				
				
				
				#-------------------------------------x
                local output=$(cat $textg | tr -d '\n')  >&2;

                if [ -z "$output" ];
                then
                    echo '{{ Bold "Open.ai servers are probably down or unreachable, try again..." ' | gum format -t template >&2;
                    return 1;
                fi		
				
			    gum style "INPUT: saved at $askg" "$input" "OUTPUT: saved at $textg" "$output" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
                gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read output?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $textg; 
                
				echo '{{ Bold "[+] sgpt started" }}' | gum format -t template >&2;
                }
		    else
                echo '{{ Color "50" "0" " t2a-sgpt is set on the system." }}' | gum format -t template >&2;
            fi
        fi


		if ! command -v gtts-cli --version 2>/dev/null 1>&2;
		then
            echo '{{  Color "99" "0" " gtts-cli is not intalled on your system, please install it and re-try" }}' | gum format -t template >&2;
            echo "t2a-gtts is disabled" >&2;
        else
		    if ! type t2a-gtts 2>/dev/null 1>&2;
            then
		        t2a-gtts ()
                {
			    echo '{{ Bold "[!] gtts started" }}' | gum format -t template >&2;

                local input="$1";
                [ -f $textg ] && local input=${input:-$(echo $textg)} || local input=${input:-$(echo $(gum file $PWD))};

                local output="$2";
     			local output="$voiceg";

                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
				
                #desc
         	    gum style "using gtts for voiceg generation." "INPUT: saved at $input" "OUTPUT: audiog saved at $voiceg" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";                

                #spinner + gtts command
                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using gtts to transform textg to audiog..." --\
                gtts-cli -l ${lang} -f $textg --output $output;
			    echo '{{ Bold "[+] gtts OK" }}' | gum format -t template >&2;
		        }
		    else
                echo '{{ Bold "t2a-gtts is set on the system" }}' | gum format -t template >&2;
            fi
        fi

		if ! command -v ffmpeg --version 2>/dev/null 1>&2;
		then
            echo "ffmpeg is not installed on your system.  Install it and re-try" >&2;
            echo "t2a-ffmpeg is disabled" >&2;
        else
		    if ! type t2a-ffmpeg 2>/dev/null 1>&2;	
            then
		        t2a-ffmpeg ()
                {
			    echo '{{ Bold "[!] ffmpeg started" }}' | gum format -t template >&2;

                local input="$1";
                [ -f $voiceg ] && local input=${input:-$(echo $voiceg)} || local input=${input:-$(echo $(gum file $PWD))};

                local output="$2";
                local output=$voiceg

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
                echo '{{ Bold "t2a-ffmpeg is set on the system" }}' | gum format -t template >&2;
            fi
        fi		

		t2a-sgpt "$1" && t2a-gtts && t2a-ffmpeg;
	}
else
    echo '{{ Bold "t2a is set on the system" }}' | gum format -t template >&2;
fi
e