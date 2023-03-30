
lang=${lang:-$(echo ${LANG:0:2})};

filter=filter.rnn && wget -qO $filter https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn

session=${session:-$(echo "$(wget -qO - http://frightanic.com/goodies_content/docker-names.php)-$(date '+%Y-%m-%d-%H')" )};	
	



audiow="/dev/shm/audiow_$session.mp3"
voicew="/dev/shm/voicew_$session.mp3"
textw="/dev/shm/textw_$session.txt"
tradw="/dev/shm/tradw_$session.txt"
subw="/dev/shm/subw_$session.srt"


voiceg="/dev/shm/voiceg_$session.mp3"
audiog="/dev/shm/audiog_$session.mp3"
textg="/dev/shm/textg_$session.txt"
askg="/dev/shm/askg_$session.txt"
subg="/dev/shm/subg_$session.srt"
input=""
output=""
tmp=""

if ! type a2s 2>/dev/null 1>&2;
then
    a2s ()
	{
        if ! command -v whisper-ctranslate2  2>/dev/null 1>&2;
		then
            echo "whisper-ctranslate2 is not installed on your system.  Install it: pip install -U whisper-ctranslate2" >&2;
            echo "o-whis is disabled" >&2;
		elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
        else
		    if ! type a2s-whisp 2>/dev/null 1>&2;
            then
						
				echo '{{ Bold "[*] session: '$session' " }}' | gum format -t template >&2;
				
		        a2s-whisp ()
                {
                echo '{{ Bold "[!] whsiper subtitles started" }}' | gum format -t template >&2;

                SECONDS=0;

		        #language spoken in the audio, specify None to perform language detection (default: None)
                #local formlangsub=""
#                local tolangsub="$1"
                #local tolangsub=${tolangsub:-$(echo "en")};
  #              local formatsub="$2";
                local formatsub=${formatsub:-$(echo "srt")};
                local model=${model:-$(echo "medium")};
				#if input text exis then set it as input, if not select it
				
  				local newest_file=$(stat -c '%Y %n' /dev/shm/*.mp3 | sort -nr | head -n1 | cut -d' ' -f2);
				#local mp3_file=$(ls -t /dev/shm/*.mp3 | head -1) ;  # find newest *.mp3 file
  				#local xyz_file=$(ls -t /dev/shm/*.xyz | head -1);   # find newest *.xyz file
				
  				#if [[ $(stat -c %Y "$mp3_file") -gt $(stat -c %Y "$xyz_file") ]]; then
    			#	newest_file="$mp3_file";
  				#else
    			#	newest_file="$xyz_file";
  				#fi
                
				echo '{{ Bold "[!] most recent file --> '$newest_file'" }}' | gum format -t template >&2;
				
				local input="$1";
				
                [ -f $newest_file ] && local input=${input:-$(echo $newest_file)} || local input=${input:-$(echo $(gum file $PWD))}; 
                
				#output definition 
    			local output="$subw"; 
			
			    gum style "INPUT audio located at: $input" "INput audio language: auto" "OUTPUT subtitles saved at $output" "OUTput language: auto" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";

                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Whisper for subtitles creation..." --\
                whisper-ctranslate2 $input --output_format $formatsub --task transcribe --compute_type int8 --output_dir /dev/shm/ ;
                #choose best model
				
				
                mv "${input%.*}.$formatsub" $output;

                gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read subtitles?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $output;
                echo '{{ Bold "[+] subtitles OK" }}' | gum format -t template >&2;
                echo '{{ Bold "[t] completed in '$SECONDS' seconds" }}' | gum format -t template >&2;
				
				
				echo '{{ Bold "DONE! what now?" }}' | gum format -t template >&2;
		
				CHOICE=$(gum choose --item.foreground 250 "edit function sourcecode" "edit output subtitles in glow" "play input audio" "help" "contribute to aiyu");
				[[ "$CHOICE" == "edit function sourcecode" ]] && $EDITOR $(gum filter --value="a2s" --height=9);
				[[ "$CHOICE" == "edit output subtitles in glow" ]] && cp $subw "${subw::-4}.md" && glow "/dev/shm/";
				[[ "$CHOICE" == "play input audio" ]] && ffplay -nodisp -autoexit -loglevel fatal $input;
				[[ "$CHOICE" == "help" ]] && glow -p README.md;
				[[ "$CHOICE" == "contribute to aiyu" ]] && echo "Great! I thought so, thank you for making $(gum style --bold "aiyu") is the best! leave a $(gum style --bold "star") if you like this. Go to: https://github.com/GabrieleRisso/aiyu";
				
		        }
		    else
                echo "a2s-whisp is set on the system. To use it: o-a2s \"subtitleformat\" " >&2;
            fi
        fi

		a2s-whisp "$1";

	}
else
    echo '{{ Bold "a2s is set on the system" }}' | gum format -t template >&2;
fi
