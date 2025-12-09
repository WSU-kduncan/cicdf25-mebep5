# Project 5 READ ME :D
# Overview
- The **GOAL** of this project is to allow for seamless updating of a container on AWS providing quick reliable image updates to the container.
- Tools used in the project are below
  - AWS is our cloud provider allowing us a server instance to host our other tools on
  - Docker allows the creation of containers which let us provide reproducable, fast deployments of an application
  - adhans webhook bridges our GitHub pushes to our AWS instance which automates the container being reloaded after an update.
![Diagram](https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project5/DiagramP5.png)

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
- To run the container, simply run the command `docker run -d --name CONTAINER_NAME -p PORT_MAP image`. This specifically runs it in detached mode using the -d flag. If you wanted to debug your container and see processes as they happen to make sure its working properly, use the -it flag instead. I recommend once everything is figured out, to use the -d flag as this is running the container in the background so you arent eating up memory or resources as much having a terminal open displaying processes happening.
- To verify that the container is successfully serving the web application, there are two ways. One way is to just use the curl command on localhost on port 80. The other command is to navigate to the instances public IP on a web browser on port 80 and see if it is displaying the web content.
## Scripting Container Application Refresh
- The bash script stops an old container with the name `mywebsitetest` and removes it then pulls the latest image from the provided dockerhub repo and starts it. This container will be persistent through machine restarts and be connected with the port number 80:80 to connect to a web service.
- To test if the script is successfully doing its taskings is by running it! First, run the script using ./containerscript.sh and you should see a bunch of messages popping up and stating if it worked and is up and running! To verify its taskings properly, you will need to check the docker processes to see if it is running using the command `docker ps`. From there you can try to curl the localhost to see if it is serving the latest content uploaded to DockerHub.
### Link to Bash Script
https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project5/deployment/containerscript.sh

# Deployment of Webhook

## Installing adhanh's webhook
- To install the webhook, you must run the command `sudo apt install webhook`. This will install webhook easily onto your ubuntu machine.
- To verify the installation worked, run the command `webhook --version`. This should display the version of the webhook application and will only display if it was installed properly.
## Summary of Webhook Definition File
- The id is the identifier for the hook becoming a piece of the URL path.
- execute-command runs a bash script in the specified path when the webhook is triggered.
- response-message just outputs a message so we can tell when the webhook is triggered.
- trigger-rule is the way to verify if a payloads trigger comes from a trusted source. There are various rules we have set that will determine it.
    - In the type field there is `payload-hmac-sha256` this is for GitHub to be able to send the secret to the webhook as it sends it in encrypted text.
    - The secret is what github uses to verify that there is a payload being sent kind of like a key!
    - Parameter tells the webhook where to look for the value it should authenticate.
## Verify Webhook
- To verify the definition file was loaded by the webhook, there is a simple curl command you can do that is `curl -X POST http://instanceip:9000/hooks/refresh-container -H "X-Hub-Signature: Bnakel123"` This shows the response-message after the webhook is sent which is just Yippe it worked!
- To verify the webhook is receiving payloads that trigger it, there is a command you can run to read the logs in real time and its just reading the journalctl of the webhook. The command is `sudo journalctl -u webhook -f` This basically just is a tool that is used to view logs collected by systemd. -u is used to determine what service is used which is in this case webhook.service. -f is used to keep the terminal live printing the logs as they come in.
- To verify if your docker container restarted, check the uptime/creation date using `docker ps`.
### Link to definition file
https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project5/deployment/hooks.json

## Configure a webhook service on the EC2 Instance
- Within the webhook service file, there are many things that are needed.
- Unit Section
    - After=network.target makes sure that the service only is started after you are connected to the network. This makes sure that the webhook will actually work because it needs to be able to connect to the internet for http to work.
- Service Section
    - This section defines how the webhook actually runs.
    - ExecStart basically defines the startup command for the service. This is very important to start the webhook on the startup of the machine.
    - User just determineds what user runs the process.
    - WorkingDirectory sets the absolute path to the directory being used to make sure no errors occur. 
- Install Section
    - WantedBy makes sure the service starts automatically when the system boots into multi user mode which lets us login to ssh and do other services at the same time.
## How to enable and start the webhook service
- To enable the webhook service, you have to run 3 commands `sudo systemctl daemon-reload` Which just makes sure that your webhook config file is upto date with the systemd manager. Next, you will run `sudo systemctl enable webhook` to enable the webhook service. Finally, if your webhook isn't showing that it is started yet using `sudo systemctl status webhook`, you will run the command `sudo systemctl start webhook`. Then it should work!
- To verify the webhook service is capturing payloads and triggering the bash script, you can run the command `sudo journalctl -u webhook -f` which is described above on what the command actually does. But, the logs you are looking for is, you should see a line that says `matched hook: refresh-container` as well as `executing command: /home/ubuntu/containerscript.sh` which shows that it identified the hook as well as executed the bash script. This can be verified after CURLing while the webhook is active.
## Link to webhook service file
https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project5/deployment/webhook.service

# Configuring a Payload Sender
- I chose GitHub instead of DockerHub as the payload sender. This is because I felt like it made more sense to me to use GitHub as they have a webhook integration that works pretty seamlessly. I didn't look much into DockerHub because I feel that creating a secure password that gets encrypted and used as a key feels more secure to me.
- To enable GitHub to send payloads to the EC2 webhook listener, you have to go to your repository, then settings, webhooks, and add webhook. Then, you will have to set the payload URL. This should be something like `http://ec2ip:9000/hooks/refresh-container`. 
- Then, choose `application/json` as the content type.
- Create a secret to secure the payloads
- Then select events to push.
## Trigger that Sends Payloads
- Pushing to your GitHub repo with a tag within the commit will cause the workflow to push to DockerHub while the webhook pulls the new information from DockerHub via the payload hence giving us life (or a working container).
## Successful payload delivery
- You can tell if the payload is successful because of the command we have stated above again which within your CLI for the EC2 Instance, `sudo journalctl -u webhook -f`. 
- To verify that payloads are only coming to allowed sources, you can try to use the CURL command on your webhook and see if it gives a response stating it worked. If it did not work, you will receive a message stating that the rules were not met. If you try and push to your GitHub, you will see in the logs as stated above, that it should work seamlessly. 

# Resources
[Adanhs Webhook](https://github.com/adnanh/webhook)
[Systemd Service Help](https://linuxhandbook.com/create-systemd-services/)
[Workflow Help](https://levelup.gitconnected.com/automated-deployment-using-docker-github-actions-and-webhooks-54018fc12e32)
[Github Webhook Documentation](https://docs.github.com/en/webhooks)
