fboulnois_stable-diffusion-docker_ Run the official Stable Diffusion releases in a Docker container with txi2img, img2img, depth2img, pix2pix, upscale4x, and inpaint.



filter=filter.rnn && wget -qO $filter https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn

session=${session:-$(echo "$(wget -qO - http://frightanic.com/goodies_content/docker-names.php)-$(date '+%Y-%m-%d-%H')" )};




audiow="/dev/shm/audiow_$session.mp3"
voicew="/dev/shm/voicew_$session.mp3"
textw="/dev/shm/textw_$session.txt"
tradw="/dev/shm/tradw_$session.txt"
subw="/dev/shm/subw_$session.srt"
imgw="/dev/shm/imgw_$session.png"


voiceg="/dev/shm/vocieg_$session.mp3"
audiog="/dev/shm/audiog_$session.mp3"
textg="/dev/shm/textg_$session.txt"
askg="/dev/shm/askg_$session.txt"
subg="/dev/shm/subg_$session.srt"
imgg="/dev/shm/imgg_$session.png"


input=""
output=""
tmp=""

#not tested

if ! type i2i 2>/dev/null 1>&2;
then
    i2i ()
	{
		
	    if ! command -v docker --version 2>/dev/null 1>&2;
	    then
            echo " docker is not installed on your system. Install it: https://docs.docker.com/engine/install and re-try" >&2;
            echo "sdimgi is disabled" >&2;
        elif ! command -v gum --version 2>/dev/null 1>&2;
	    then
            echo " gum is not installed on your system. Install it: https://github.com/charmbracelet/gum#installation and re-try" >&2;
            echo "sdimgi is disabled" >&2;
        else
		    if ! type sdimgi 2>/dev/null 1>&2;
            then
				
				echo '{{ Bold "[*] session: '$session' " }}' | gum format -t template >&2;

		        sdimgi ()
                {
				
				
				echo '{{ Bold "[!] i2i started" }}' | gum format -t template >&2;
				
  				local newest_filet=$(stat -c '%Y %n' /dev/shm/*.txt | sort -nr | head -n1 | cut -d' ' -f2);

				local inputt="$1";
				[ -f $newest_file ] && local inputt=${inputt:-$(echo $newest_file)} || local inputt=${inputt:-$(echo $(echo $(gum input --char-limit=4000 --placeholder="Type something here, just ask me!" --width="$(($COLUMNS-5))" --header="I'm an AI use me wisely!" --header.italic --header.border="rounded" --header.foreground="50" ))};

				local inputv="$2";
  				local $newest_filev=$(stat -c '%Y %n' $PWD/output/*.png | sort -nr | head -n1 | cut -d' ' -f2);
				[ -f $newest_filev ] && local inputv=${inputv:-$(echo $newest_filev)} || local inputv=${inputv:-$(echo $(gum file $PWD))};
				
				echo '{{ Bold "[!] most recent possible prompt --> '$newestt_file'" }}' | gum format -t template >&2;
				echo '{{ Bold "[!] most recent image --> '$newestv_file'" }}' | gum format -t template >&2;
				
				if [ -z "$inputv" ] || [ -z "$inputt" ]; #check that text and voice are set
                then
                    echo "bad inputs" >&2;
                    return 1;
                fi
                
                echo $input > $askg >&2;

                gum spin -s points --show-output --spinner.foreground="50" --title.bold --spinner.margin="0 1" --title "using Docker to interact with stable diffusion..." --\
                ./build.sh run --image "$inputv" "$inputt"; #https://github.com/fboulnois/stable-diffusion-docker#huggingface-token
				
  				local output=$(stat -c '%Y %n' $PWD/output/*.png | sort -nr | head -n1 | cut -d' ' -f2);


                if [ -z "$output" ];
                then
                    echo '{{ Bold "someting went wrong, check https://github.com/fboulnois/stable-diffusion-docker and try again...' | gum format -t template >&2;
                    return 1;
                fi		
				
			    gum style "INPUT: saved $askg" "$input" "OUTPUT: image saved at $output" "SESSION: $session" --foreground 15 --border-foreground 50 --border rounded --width="$(($COLUMNS -4))" --italic --margin "1 1" --padding "0 1";

                
				echo '{{ Bold "[+] sdimg started" }}' | gum format -t template >&2;
                }
		    else
                echo '{{ Color "50" "0" " i2i-sdimgi is set on the system." }}' | gum format -t template >&2;
            fi
        fi


		i2i-sdimgi "$1";
	}
else
    echo '{{ Bold "i2i is set on the system" }}' | gum format -t template >&2;
fi
