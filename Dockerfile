# Use Windows Server Core with .NET as base
FROM mcr.microsoft.com/dotnet/sdk:6.0-windowsservercore-ltsc2019

# Install Node.js
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV NODE_VERSION 18.17.1
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-x64.msi

RUN Invoke-WebRequest $env:NODE_DOWNLOAD_URL -OutFile 'node.msi' ; \
    Start-Process msiexec.exe -ArgumentList '/i', 'node.msi', '/quiet', '/norestart' -NoNewWindow -Wait ; \
    Remove-Item -Force node.msi

# Update PATH to include Node.js
RUN $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';C:\Program Files\nodejs' ; \
    [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')

# Create app directory
WORKDIR C:\\app

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY src/ ./src/

# Build TypeScript
RUN npx tsc

EXPOSE 3000

# Use PowerShell to execute npm command
CMD ["powershell", "-Command", "npm start"]
