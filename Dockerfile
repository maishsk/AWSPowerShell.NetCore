FROM microsoft/powershell:6.0.2-ubuntu-14.04

LABEL maintainer="Maish Saidel-Keesing <https://twitter.com/maishsk>" \
      description="This Docker image will allow you to run commands with PowerShell against your AWS infrastructure"

## Install the AWS Powershell module
RUN pwsh -c \
    Install-Package -Name AWSPowerShell.NetCore -Source \
    https://www.powershellgallery.com/api/v2/ -ProviderName \
    NuGet -ExcludeVersion -Force -Destination \
    ~/.local/share/powershell/Modules
