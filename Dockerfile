FROM microsoft/powershell:latest

LABEL maintainer="Maish Saidel-Keesing <maishsk@gmail.com>" \
      description="This Docker will allow you to run commands with PowerShell against your AWS infrastructure"

## Install the AWS Powershell module
RUN pwsh -c \
    Install-Package -Name AWSPowerShell.NetCore -Source \
    https://www.powershellgallery.com/api/v2/ -ProviderName \
    NuGet -ExcludeVersion -Force -Destination \
    ~/.local/share/powershell/Modules
