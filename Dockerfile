# Docker image file that describes an Ubuntu18.04 image with PowerShell installed from Microsoft APT Repo
ARG fromTag=18.04
ARG imageRepo=ubuntu

FROM ${imageRepo}:${fromTag} AS installer-env

ARG PS_VERSION
ARG PS_PACKAGE=powershell_${PS_VERSION}-1.ubuntu.18.04_amd64.deb
ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}

RUN echo PS_PACKAGE_URL is set to ${PS_PACKAGE_URL}

# Download the Linux package and save it
ADD ${PS_PACKAGE_URL} /tmp/powershell.deb

# Define ENVs for Localization/Globalization
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

# Install dependencies and clean up
RUN apt-get update \
    && apt-get install -y /tmp/powershell.deb \
    && apt-get install -y \
    # less is required for help in powershell
        less \
    # required to setup the locale
        locales \
    # required for SSL
        ca-certificates \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen $LANG && update-locale \
    # remove powershell package
    && rm /tmp/powershell.deb \
    && pwsh -c \
    Install-Package -Name AWSPowerShell.NetCore -Source \
    https://www.powershellgallery.com/api/v2/ -ProviderName \
    NuGet -ExcludeVersion -Force -Destination \
    ~/.local/share/powershell/Modules

LABEL maintainer="Maish Saidel-Keesing <https://twitter.com/maishsk>" \
      readme.md="https://github.com/maishsk/AWSPowerShell.NetCore/blob/master/README.md" \
      description="This Docker image will allow you to run commands with PowerShell against your AWS infrastructure" \
      org.label-schema.version=${PS_VERSION}

CMD [ "pwsh" ]
