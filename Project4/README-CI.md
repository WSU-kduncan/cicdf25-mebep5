# Building a Web Service Container
This site consists of HTML/CSS with a button to go to the other page talking about me and my interests.
Since the site is not active unless my AWS instance is active, it wont resolve to the web page. But a link to it in the repository would be ![here](https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project4/Dockerfile)

The docker file tells docker to use apaches official http server image version 2.4 and copies everything from my local machines directory into the containers apache document root. You can see the docker image ![here](https://hub.docker.com/r/mebep5/mywebsite2)

You can build a docker image by doing the simple command `docker build -t myimage .` This will build an image from your DockerFile in the directory. 

Next, if you want to push it to the DockerHub repository, you will need to tag your image. To do this, you will run the command `docker build -t myusername/myimage:latest .` Now that your tagging is done, you must push the image to the repository. To do this, you must login to docker with the `docker login` command. Finally, after logging in you will push the image to the repository using the command `docker push myusername/myimage:latest`. That is it! you will have successfully pushed your image to the DockerHub repository.

# How to Run a Container that serves a Web App
It is very simple to run a container that serves a web application. 

After the steps above, you should be able to simply run the command, `docker run -d -p 8080:80 myusername/myimage:latest` This will now run the container on a local host using port 8080!
# GitHub Actions and DockerHub
## Creating a Personal Access Token (PAT)
- To create a PAT, you must login to the DockerHub website.
- Go to Account Settings, then Security, then New Access Token.
- Give the token a name and a scope, Read & Write Access will work.
- Finally, Copy the token immediately as you will not be able to see it again.

## Workflow Trigger
The workflow is configured to run whenever code is pushed to the main branch. This makes sure that new changes are built and pushed as a Docker Image all completely automated.
## Workflow Steps
- The first step pulls the repository code into the Github actions runner.
- The second step logs you into DockerHub by authenticating using repository secrets. 
- The third step sets up Docker Buildx which enables docker build features which allows for the automation to actually work.
- The fourth step builds an image using the Dockerfile and pushes it to DockerHub using the tag `${{ secrets.DOCKER_USERNAME }}/mywebsite2:latest` 
## Values to update if in different repository
## Changes in the Workflow
- context and file paths need to be updated depending on where the Dockerfile is stored.
- tags need to change to match the DockerHub repository and image name you want to push to.
## Changes in the Repository
- Secrets need to be changed ensuring that you have the correct DockerHub username and token so it will go to the right repository.

## Link to Workflow
![Here](https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/.github/workflows/main.yml)
# Testing & Validating
## How to Test that the Workflow did its Tasking
- You push a commit to main branch of the repository.
- Go to the Actions tab in GitHub and confirm that the workflow ran successfully.
- Check the logs for the Build and Push Docker Images step to make sure the image was pushed without any errors.
## How to Verify the image in DockerHub works
- Go to your DockerHub account and fonrim the image appears on the repository.
- Pull and run the image locally to test it using the command `docker pull dockerusername/mywebsite:latest` then run `docker run -p 8080:80 dockerusername/mywebsite:latest` and you should be able to navigate to the website `http://localhost:8080` and see content.

## Link to DockerHub Repository
![Here](https://hub.docker.com/r/mebep5/mywebsite2)




