FROM cockroachdb/cockroach AS base


FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
COPY --from=base /cockroach/cockroach /usr/local/bin/
WORKDIR /app
COPY . .
RUN dotnet add package Npgsql --version 7.0.0
