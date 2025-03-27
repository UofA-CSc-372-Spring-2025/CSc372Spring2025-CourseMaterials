# README for Oct 16th Chapel Tutorial

After following the below instructions to install docker on your Mac, Linux, or Windows
laptop, then do a
```
  docker pull docker.io/chapel/chapel-gasnet
```

Next follow the instructions at https://hub.docker.com/r/chapel/chapel to compile
a hello world in Chapel, but use the chapel-gasnet container and when you run the
“hello” executable specify -nl 1.  Here are the commands to use:
```
echo 'writeln("Hello, world!");' > hello.chpl

docker run --rm -it -v "$PWD":/myapp -w /myapp chapel/chapel-gasnet /bin/bash

root@xxxxxxxxx:/myapp# chpl hello.chpl
root@xxxxxxxxx:/myapp# ./hello -nl 1
Hello, world!
```

## Instructions from the "How to do hands on" slide

Zip file with example codes and slides
* https://chapel-lang.org/tmp/ChapelTutorialSlidesAndCodes.zip

Using a container on your laptop
* First, install docker for your machine and start it up (see the README.md for more info)
* Then, use the chapel-gasnet docker container
```
 docker pull docker.io/chapel/chapel-gasnet    # takes about 5 minutes
 cd ChapelTutorialSlidesAndCodes   # assuming zip file has been unzipped
 docker run --rm -it -v "$PWD":/myapp -w /myapp chapel/chapel-gasnet /bin/bash
 root@xxxxxxxxx:/myapp# chpl 01-hello.chpl
 root@xxxxxxxxx:/myapp# ./01-hello -nl 1
```

Attempt this Online website for running Chapel code
* Go to main Chapel webpage at https://chapel-lang.org/
* Click on the little ATO icon on the lower left that is above the YouTube icon


## Installing Docker

### Mac

Download the docker desktop for Intel or Arm as appropriate from
https://docs.docker.com/get-docker/.

Start up docker desktop.  You do not need a docker account.


### Linux

* First three steps on https://docs.docker.com/engine/install/ubuntu/
  1. Set up Docker's Apt repository.
```
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Add the repository to Apt sources:
  echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg]   https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
```

  2. Install the Docker packages.
```
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

  3. Verify that the Docker Engine installation is successful by running the hello-world image.
```
  sudo docker run hello-world
```


* Additional steps
```
  sudo groupadd docker
  sudo usermod -aG docker ${USER}

  # maybe not necessary
  sudo chmod 666 /var/run/docker.sock

```

### Windows

1. download docker for windows from: https://docs.docker.com/desktop/install/windows-install/
  a. when promted to log in or create an account, select continue without logging in

2. open a Powershell terminal (preferably as admin)
  a. if you don't have WSL installed, execute `wsl --install`
  b. next, ensure that your Ubuntu distro is using WSL2 (rather than WSL1).
  Execute `wsl -l -v` and ensure that ubuntu says 2 under version.
   i. If it is on version 1, execute `wsl --set-version ubuntu 2` (may take some time)

3. open the docker desktop app to start the docker daemon
  a. you can check that docker is using WSL Ubuntu by going to
  Settings > Resources > WSL Integration

4. in Powershell, execute docker pull chapel/chapel-gasnet

*NOTE*: For Windows you will probably have to replace the `$PWD` from the instructions
at https://hub.docker.com/r/chapel/chapel with the Windows version of the current path
written out

