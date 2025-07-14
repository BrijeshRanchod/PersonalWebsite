# Use official ASP.NET Core runtime as base
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project files
COPY *.sln .
COPY MyPortfolio/*.csproj ./MyPortfolio/
RUN dotnet restore MyPortfolio/MyPortfolio.csproj

COPY . .
WORKDIR /src/MyPortfolio
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyPortfolio.dll"]
