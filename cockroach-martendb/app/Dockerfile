FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY . .
RUN dotnet add package Npgsql --version 6.0.1
RUN dotnet add package Marten --version 5.11.0
