FROM microsoft/powershell:latest

LABEL maintainer="Maish Saidel-Keesing <maishsk@gmail.com>" \
      description="This Docker will allow you to run commands with PowerShell against your AWS infrastructure"
      readme.md="https://github.com/maishsk/AWSPowerShell.NetCore/blob/master/README.md" \
      org.label-schema.usage="https://github.com/maishsk/AWSPowerShell.NetCore/blob/master/README.md#using-the-container" \
      org.label-schema.url="https://github.com/maishsk/AWSPowerShell.NetCore/blob/master/README.md" \
      org.label-schema.vcs-url="https://github.com/maishsk/AWSPowerShell.NetCore" \
      org.label-schema.name="AWSPowerShell" \
      org.label-schema.vendor="AWSPowerShell" \

## Install the AWS Powershell module
RUN pwsh -c \
    Install-Package -Name AWSPowerShell.NetCore -Source \
    https://www.powershellgallery.com/api/v2/ -ProviderName \
    NuGet -ExcludeVersion -Force -Destination \
    ~/.local/share/powershell/Modules
