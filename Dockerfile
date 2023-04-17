FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["kittyservice.csproj", "./"]
RUN dotnet restore "kittyservice.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "kittyservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "kittyservice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "kittyservice.dll"]
