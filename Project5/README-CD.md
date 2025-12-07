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
- The bash script 