ARG DOCKER_PASSWORD
ARG DOCKER_URL
ARG DOCKER_USERNAME

FROM microsoft/dotnet:2.2-sdk AS installer-env

COPY . /src/dotnet-function-app
RUN cd /src/dotnet-function-app && \
    mkdir -p /home/site/wwwroot && \
    dotnet publish *.csproj --output /home/site/wwwroot

FROM mcr.microsoft.com/azure-functions/dotnet:2.0-appservice

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    DOCKER_REGISTRY_SERVER_USERNAME=${DOCKER_USERNAME} \
    DOCKER_REGISTRY_SERVER_PASSWORD=${DOCKER_PASSWORD} \
    DOCKER_REGISTRY_SERVER_URL=${DOCKER_URL}

COPY --from=installer-env ["/home/site/wwwroot", "/home/site/wwwroot"]