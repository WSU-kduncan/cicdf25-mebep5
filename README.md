# READ ME!!! 
## Overview
This repository contains two of my projects which goals are to ultimately deploy a containerized web service using AWS, Docker, GitHub Actions, and Webhooks. 

The goal is to automate imaging, pushing, and updating Docker containers for a web application for fast and easy fixes or tweaks.

## Repository Contents
- ![Project 4](https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project4/README-CI.md) consists of Dockerfile and workflow setup for compiling and pushing images to DockerHub.
  - Dockerfile with with an Apache web service container
  - Documentation on how to build, tag, and push Docker images.
- ![Project 5](https://github.com/WSU-kduncan/cicdf25-mebep5/blob/main/Project5/README-CD.md) consists of scripts, webhook configuration, and AWS instance setup for an automatic container updater that pulls directly from DockerHub.
  - Bash script to stop old containers, pull the latest docker image, and restart the service.
  - Webhook definition file that triggers rules, validates authenticity, and executes a command.
  - Webhook Service file that keeps the webhook running on the AWS instance.
- ![Github Workflows](https://github.com/WSU-kduncan/cicdf25-mebep5/tree/main/.github/workflows)
  - Contains a github actions workflow that automates docker image building, pushes images to docker, and supports semantic versions with Git tags.
