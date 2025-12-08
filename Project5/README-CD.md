# Project 5 READ ME :D

## EC2 Instance Details

### AMI
- Ubuntu 24.04 LTS Server - I like Ubuntu and its way cheaper than windows!
### Instance Type
- t2.medium because it was recommended in the project/specs looked good enough to be useful and worse enough to not eat the funding too quick.
### Volume Size
- 30 Gb (recommended)
### Security Group
- SSH Access (port 22)  on Campus and on Home Internet (Havent gotten my home IP yet) so I can connect to it only to places also making it secure from outside attackers if they are not on campus.
- HTTP Access (port 80) on Campus and on Home Internet because of the security of the tight IP range.
- All outbound traffic allowed (0.0.0.0/0) because the instance wont be sending anything out specifically except the containers so just allowing all makes it easy.

## Docker Setup
- To install docker for OS on the EC2 instance there are a couple of ways. I personally installed it using snap. To do this, you must make the command `sudo snap install docker` which simply just installs docker to the OS. There isnt any dependencies needed hence me using Ubuntu! :)
- To confirm Docker is installed, you can simple try any docker command but a simple one is just typing the word `docker` and it should pop up a help page with commands you can use. 
- Proof you can run containers will be in the next section for simplicity and not duplicate words.
- It doesn't state that you need to login on the Project taskings but to login to docker to connect your machine to DockerHub, you must do the command `docker login` and then you are prompted with a link that connects your machine and DockerHub with a simple code. You can also use a token but I did not want to have to go grab it as it basically just does the same thing. 
## Testing on EC2 Instance
- To pull a container image from the DockerHub repository, you must be logged into docker and then run the command `docker pull dockerhubusername/dockerrepo:tag`. This will pull the image in the dedicated repository to the local device.
- To run the container, simply run the command `docker run -d --name CONTAINER_NAME -p PORT_MAP image`. This specifically runs it in detatched mode using the -d flag. If you wanted to debug your container and see processes as they happen to make sure its working properly, use the -it flag instead. I recommend once everything is figured out, to use the -d flag as this is running the container in the background so you arent eating up memory or resources as much having a terminal open displaying processes happening.
- To verify that the container is successfully serving the web application, there are two ways. One way is to just use the curl command on localhost on port 80. The other command is to navigate to the instances public IP on a web browser on port 80 and see if it is displaying the web content.
## Scripting Container Application Refresh
- The bash script stops an old container with the name `mywebsitetest` and removes it then pulls the latest image from the provided dockerhub repo and starts it. This container will be persistent through machine restarts and be connected with the port number 80:80 to connect to a web service.
- To test if the script is successfully doing its taskings is by running it! First, run the script using ./containerscript.sh and you should see a bunch of messages popping up and stating if it worked and is up and running! To verify its taskings properly, you will need to check the docker processes to see if it is running using the command `docker ps`. From there you can try to curl the localhost to see if it is serving the latest content uploaded to DockerHub.
### Link to Bash Script
https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project5/deployment/containerscript.sh

# Deployment of Webhook

## Installing adhanh's webhook
- To install the webhook, you must run the command `sudo apt install webhook`. This will install webhook easily onto your ubuntu machine.
- To verify the installation worked, run the command `webhook --verison`. This should display the version of the webhook application and will only display if it was installed properly.
## Summary of Webhook Definition File
- The id is the identifier for the hook becoming a piece of the URL path.
- execute-command runs a bash script in the specified path when the webhook is triggered.
- response-message just outputs a message so we can tell when the webhook is triggered.
- trigger-rule is the way to verify if a payloads trigger comes from a trusted source. There are various rules we have set that will determine it.
    - In the type field there is `payload-hmac-sha256` this is for GitHub to be able to send the secret to the webhook as it sends it in encrypted text.
    - The secret is what github uses to verify that there is a payload being sent kind of like a key!
    - Parameter tells the webhook where to look for the value it should authenticate.

