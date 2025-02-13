@echo off
setlocal

cd /d "%~dp0"

rem コンテナ起動
docker compose up -d

pause

endlocal