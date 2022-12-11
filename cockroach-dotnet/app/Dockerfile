FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY . .
RUN dotnet add package Npgsql --version 7.0.0
#RUN dotnet run
