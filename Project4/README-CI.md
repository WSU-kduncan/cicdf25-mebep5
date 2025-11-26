# Building a Web Service Container
This site consists of HTML/CSS with a button to go to the other page talking about me and my interests.
Since the site is not active unless my AWS instance is active, it wont resolve to the web page. But a link to it in the repository would be ![here](https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project4/Dockerfile)

The docker file tells docker to use apaches official http server image version 2.4 and copies everything from my local machines directory into the containers apache document root. You can see the docker image ![here](https://hub.docker.com/r/mebep5/mywebsite2)

You can build a docker image by doing the simple command `docker build -t myimage .` This will build an image from your DockerFile in the directory. 

Next, if you want to push it to the DockerHub repository, you will need to tag your image. To do this, you will run the command `docker build -t myusername/myimage:latest .` Now that your tagging is done, you must push the image to the repository. To do this, you must login to docker with the `docker login` command. Finally, after logging in you will push the image to the repository using the command `docker push myusername/myimage:latest`. That is it! you will have successfully pushed your image to the DockerHub repository.

# How to Run a Container that serves a Web App
It is very simple to run a container that serves a web application. 

After the steps above, you should be able to simply run the command, `docker run -d -p 8080:80 myusername/myimage:latest` This will now run the container on a local host using port 8080!
