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
tradg="/dev/shm/tradg_$session.txt"

subg="/dev/shm/subg_$session.srt"
input=""
output=""
tmp=""

if ! type t2tr 2>/dev/null 1>&2;
then
    t2tr ()
	{
	if ! command -v deepl -V 2>/dev/null 1>&2;
		then
            echo "deppl is not installed on your system.  Install it: pip install deppl-cli" >&2;
            echo "o-deepl is disabled" >&2;
        else
		    if ! type o-dtrans 2>/dev/null 1>&2;
            then
		        o-dtrans ()
                {
					
				 local input="$2";
                 local newest_file="";    #=$(stat -c '%Y %n' /dev/shm/*.mp3 | sort -nr | head -n1 | cut -d' ' -f2);
                 local txt_file=$(ls -t /dev/shm/*.txt | head -1) ;  # find newest *.mp3 file
                 local srt_file=$(ls -t /dev/shm/*.srt | head -1);   # find newest *.xyz file
                               
                 if [[ $(stat -c %Y "$txt_file") -gt $(stat -c %Y "$srt_file") ]]; then
                       newest_file="$txt_file";
                 else
                       newest_file="$srt_file";
                 fi
                                				
				
				local output="$tradg"; 
				
				
				#"valid languages of `--fr`:
#{'fi', 'cs', 'lv', 'nl', 'el', 'auto', 'ru', 'da', 'sv', 'it', 'uk', 'zh', 'ko', 'et', 'de', 'en', 'es', 'bg', 'lt', 'ja', 'pl', 'tr', 'id', 'sk', 'sl', 'hu', 'fr', 'ro', 'pt'}
#valid languages of `--to`:
#{'fi', 'cs', 'lv', 'nl', 'lt', 'ja', 'el', 'pl', 'ru', 'tr', 'da', 'sv', 'pt', 'id', 'it', 'sk', 'sl', 'hu', 'fr', 'uk', 'zh', 'ko', 'et', 'de', 'en', 'ro', 'es', 'bg'} "

                #langfrom="$3"
				langto="$1"
				
                langto=${langto:-$(echo "en")};
				langfrom=${langfrom:-$(echo "auto")}; #sould autodetect language
				#time=${time:-$(echo "5000")}; #timeout interval (default: 5000)
				char=$(cat $input | wc -m) #chars count
			    
				if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
    		    echo "using deepl for translation generation" >&2;
				
				gum style  "input text: $input" "language from: $langfrom" "output: $output" "language to: $langto" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
                
                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using deepl for translation generation..." --\
				cat $input | tr -d '[:cntrl:]' | deepl -s --to "$langto" | tr -d '[:cntrl:]' > $output   #same as: deepl -f $input .
				
				echo "ok 1"
				gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read translation?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $output; 
				
				echo "[OK] deepl text to translation done."; >&2;
				echo "[=] text used to create voice archived at: $input " >&2;
				echo "[+] translated text saved at: $output "; >&2;
		        }
		    else
            echo "o-dtrans is set on the system.To use it: \"o-dtrans text.txt trans.txt \" " >&2;
            fi
        fi
		
		if ! command -v docker --version 2>/dev/null 1>&2;
		then
            echo "trad is not installed on your system. https://github.com/soimort/translate-shell " >&2;
            echo "o-ttrans is disabled" >&2;
		elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
        else
		    if ! type o-ttrans 2>/dev/null 1>&2;
            then
		        o-ttrans ()
                {
					
				 local input="$2";
                 local newest_file="";    #=$(stat -c '%Y %n' /dev/shm/*.mp3 | sort -nr | head -n1 | cut -d' ' -f2);
                 local txt_file=$(ls -t /dev/shm/*.txt | head -1) ;  # find newest *.mp3 file
                 local srt_file=$(ls -t /dev/shm/*.srt | head -1);   # find newest *.xyz file
                               
                 if [[ $(stat -c %Y "$txt_file") -gt $(stat -c %Y "$srt_file") ]]; then
                       newest_file="$txt_file";
                 else
                       newest_file="$srt_file";
                 fi
                                
               
				echo '{{ Bold "[!] most recent file --> '$newest_file'" }}' | gum format -t template >&2;
				
                [ -f $newest_file ] && local input=${input:-$(echo $newest_file)} || local input=${input:-$(echo $(gum file $PWD))};				
				
				local output="$tradg"; 
				

				local langto="$1"
				
                local langto=${langto:-$(echo "en")};
				local langfrom=${langfrom:-$(echo "auto")}; #sould autodetect language
			
			    
				if [ -z "$input" ];
                then
                    echo "No input" >&2;
                    return 1;
                fi
				
				gum style  "input text: $input" "language from: $langfrom" "output: $output" "language to: $langto" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";
                				
				local intrad=$(<"$input");
						
				gum spin --spinner points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using trad for translation generation..." -- sleep 2				
				docker run --rm -it soimort/translate-shell -shell -brief -w 10 :"$langto" "$intrad" | tail -n +3  > $output;  
				
				gum confirm --negative="no" --affirmative="yes, let's read!" "open pager to read translation?" --timeout=15s --selected.foreground="0" --unselected.foreground="44" --selected.italic --unselected.italic --selected.background="50" --prompt.italic --prompt.margin="0 0 0 $(($COLUMNS -29))" \
                && gum pager --soft-wrap --border-foreground="86" --help.foreground="200" --show-line-numbers < $output; 
				
				echo '{{ Bold "[+] translation OK" }}' | gum format -t template >&2;
				
								
								
				CHOICE=$(gum choose --item.foreground 250 "edit function sourcecode" "edit output text in glow" "edit input text in glow" "help" "contribute to aiyu");
				[[ "$CHOICE" == "edit function sourcecode" ]] && $EDITOR $(gum filter --value="t2tr" --height=9);
				[[ "$CHOICE" == "edit output translation in glow" ]] && cp $tradg "${tradw::-4}.md" && glow "/dev/shm/";
				[[ "$CHOICE" == "edit input text in glow" ]] && cp $input "${input::-4}.md" && glow "/dev/shm/";
				[[ "$CHOICE" == "help" ]] && glow -p README.md;
				[[ "$CHOICE" == "contribute to aiyu" ]] && echo "Great! I thought so, thank you for making $(gum style --bold "aiyu") is the best! leave a $(gum style --bold "star") if you like this. Go to: https://github.com/GabrieleRisso/aiyu";
				
		        }
		    else
            echo "o-ttrans is set on the system.To use it: \"o-ttrans lang file.txt \" " >&2;
            fi
        fi

		o-ttrans "$1" "$2";
		#o-dtrans "$1" "$2";
	}
else
    echo '{{ Bold "t2tr is set on the system" }}' | gum format -t template >&2;
fi
