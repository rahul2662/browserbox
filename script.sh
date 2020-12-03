#!/bin/bash 

Help()
{
   # Display Help
   echo "Syntax: script.sh [-p|h]"
   echo "options:"
   echo "-p     provide aws profile. Else specify default"
   echo "-h     Print this Help."
   echo
}

#initiating variables
DOCKER=`which docker`
AWS=`which aws`
BUCKET="bucket-name"
EXPIRY=1800

mainlogic()
        {
            if [[ -z "$AWS" ]]
                then    
                    echo "aws-cli is not installed"
                    exit 1
            fi

            echo "Enter the website name:"
            read website

            $DOCKER build -t browserbox .
            $DOCKER run -it --net=host -e DISPLAY -v $(pwd):/data:rw -v /tmp/.X11-unix   browserbox google-chrome --no-sandbox --headless --screenshot="/data/chrome.png" "$website"
            $DOCKER run -it --net=host -e DISPLAY -v $(pwd):/data:rw -v /tmp/.X11-unix   browserbox firefox --screenshot="/data/firefox.png" "$website"
            chmod +r firefox.png chrome.png

            for  browser  in chrome firefox
                do
                    $AWS s3 cp $browser.png s3://$BUCKET/ --profile $PROFILE
                    $AWS s3 presign s3://$BUCKET/$browser.png --expires-in $EXPIRY --profile $PROFILE
                done
            $DOCKER run -d --net=host -e DISPLAY -v /tmp/.X11-unix browserbox firefox $website 
            $DOCKER run -d --net=host -e DISPLAY -v /tmp/.X11-unix browserbox google-chrome --no-sandbox $website 

        }
while getopts ":h:p:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      p) # initialize profile
         PROFILE=$OPTARG
         mainlogic
         exit 0;;
      \?) # incorrect option
         echo "Error: Invalid option"
         exit 1;;
   esac
done
Help
