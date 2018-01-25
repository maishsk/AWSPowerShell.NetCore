# The AWS PowerShell container

This container has allows you to run the AWS PowerShell commands Linux or Mac.

PowerShell Version: **6.0.0**  
AWSPowerShell.NetCore: **3.3.225.0**

## Requirements
1. This should be run only on a Linux/Mac machine (Windows has Powershell built in so it does not really make sense).
2. PowerShell is not currently installed in your machine - and you do not cuyrrehave an alias to the comman
3. You already have your AWS credentials configured on your local machine. This usually resides in:  
``~/.aws``
4. Docker is installed
5. ``/usr/local/bin/`` exists and is part of your ``PATH``
6. You are successfully logged in to docker hub from your machine

## Installation
In order to replace the PowerShell command with a container - you will  create an alias and a small bash script to manage the state of the container in the background as detailed below:

```
echo "alias powershell='/usr/local/bin/powershell' >> ~/.bashrc"

cat >> /usr/local/bin/powershell << \EOF
#!/bin/bash
## First check if there is a container that exists
EXISTS=`docker ps -a | awk -F " " '{print $NF}'| grep -i powershell`

if [ $? -ne 0 ]
then
  docker run -it -v ~/.aws/:/root/.aws --name powershell maishsk/awspowershell.netcore
else
  ## Check to see if the container is running in the background
  IS_RUNNING=`docker ps -a | grep -i powershell | grep Up`
  if [ $? -ne 0 ]
  ## Container is not running - start it
  then
    docker start -i powershell
  ## Container is running in another shell - take control
  else
    docker stop powershell
    docker start -i powershell
  fi
fi
EOF

chmod +x /usr/local/bin/powershell
```  
<br>
<br>
*You will have to source your ``.bashrc`` file for this alias to take effect.*

### Using the container
Simply run ``powershell`` from your terminal

The container will mount your configuration as a persistent volume inside the container to ``/root/.aws/``.

You will need to set the correct region that you want to work with  

``Set-DefaultAWSRegion -Region us-east-1``  


Or if you would like to already use the profiles in your config file you can run the following:  


``Set-DefaultAWSRegion -ProfileLocation /root/.aws/config``


## Limitations
The wrapper used above allows for **only** one instance / session of the PowerShell container to exist at any time. This was my personal preference for my workflow - if you would like to work differently - then you will have to modify the bash script.

Please see this blog [post](http://technodrone.blogspot.com/2018/01/the-aws-powershell-docker-container.html) for more information.
