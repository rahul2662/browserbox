Working :
1. Build docker image as I was facing some issues with available public images for different browsers
2. Script will build docker image and spawns containers for respective browsers and perform required operations. Presign url will be printed as output for the script.

Content in Zip:
1. Dockerfile
2. script.sh

Commands supported by script : 
1. sudo ./script.sh -p <aws-profile-name> 
2. ./script.sh -h

This solution assumes: 
1. aws configure is already executed 
2. configured profile has access to s3 bucket. Access approach doesn't matter
3. In the script the user needs to input the bucket name for uploading the screenshots.(script line 16)# browserbox
