

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

if ! type a2a 2>/dev/null 1>&2;
then
    a2a ()
	{
	if ! command -v ffmpeg --version 2>/dev/null 1>&2;
		then
            echo "ffmpeg is not installed on your system.  Install it and re-try" >&2;
            echo "a2a-ffmpeg is disabled" >&2;
		elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
        else
		    if ! type a2a-ffmpeg 2>/dev/null 1>&2;
            then
		        a2a-ffmpeg ()
                {
			     echo '{{ Bold "[!] ffmpeg started" }}' | gum format -t template >&2;

					
				 local input="$1";
                 local newest_file="";    #=$(stat -c '%Y %n' /dev/shm/*.mp3 | sort -nr | head -n1 | cut -d' ' -f2);
                 local txt_file=$(ls -t /dev/shm/*.mp3 | head -1) ;  # find newest *.mp3 file
                 local opus_file=$(ls -t /dev/shm/*.opus | head -1);   # find newest *.xyz file
                               
                 if [[ $(stat -c %Y "$txt_file") -gt $(stat -c %Y "$opus_file") ]]; then
                       newest_file="$txt_file";
                 else
                       newest_file="$opus_file";
                 fi
                                
               
				echo '{{ Bold "[?] most recent file --> '$newest_file'" }}' | gum format -t template >&2;
				
                [ -f $newest_file ] && local input=${input:-$(echo $newest_file)} || local input=${input:-$(echo $(gum file $PWD))};				
				
				local output="$audiog"; 

                if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi

                gum style "using ffmpeg for audiog enanchemnt and output creation." "INPUT: audiog saved at $input" "OUTPUT: audiog saved at $output" "FILTER: audiog filter at $filter" "SESSION: $session" "SPEED: 1.4" "VOLUME: 1.3" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
				
				
            	ffmpeg -y -i $input -loglevel fatal -af "atempo=1.4,dialoguenhance,arnndn=m=$filter,volume=1.3" $output;
			    echo '{{ Bold "[+] ffmpeg OK" }}' | gum format -t template >&2;

				
				CHOICE=$(gum choose --item.foreground 250 "edit function sourcecode" "play input audio" "play output audio" "help" "contribute to aiyu");
				[[ "$CHOICE" == "edit function sourcecode" ]] && $EDITOR $(gum filter --value="a2t" --height=9);
				[[ "$CHOICE" == "play input audio" ]] && ffplay -nodisp -autoexit -loglevel fatal $input;
				[[ "$CHOICE" == "play output audio" ]] && ffplay -nodisp -autoexit -loglevel fatal $output;
				[[ "$CHOICE" == "help" ]] && glow -p README.md;
				[[ "$CHOICE" == "contribute to aiyu" ]] && echo "Great! I thought so, thank you for making $(gum style --bold "aiyu") the best! leave a $(gum style --bold "star") if you like this. Go to: https://github.com/GabrieleRisso/aiyu";
				
				
				
		        }
		    else
                echo '{{ Bold "a2a-ffmpeg is set on the system" }}' | gum format -t template >&2;
            fi
        fi		
		

		a2a-ffmpeg "$1";
	}
else
    echo '{{ Bold "a2a is set on the system" }}' | gum format -t template >&2;
fi