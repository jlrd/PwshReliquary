FROM mcr.microsoft.com/powershell:7.3-ubuntu-22.04

RUN /bin/pwsh -Command 'Install-Module -Name Az -AllowClobber -Scope AllUsers -Force'

WORKDIR /opt/PwshReliquary
COPY main.ps1 .

ENTRYPOINT [ "/bin/pwsh","-File" ]
CMD [ "/opt/PwshReliquary/main.ps1" ]