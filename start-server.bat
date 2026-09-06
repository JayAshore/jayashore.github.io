@echo off
title Hexo Blog Server

cd /d "%~dp0"

echo ========================================
echo          Hexo Blog Server
echo ========================================
echo.
echo Open: http://localhost:4000
echo Stop the server with Ctrl+C
echo.

call npm run server

echo.
echo Hexo server stopped.
pause
