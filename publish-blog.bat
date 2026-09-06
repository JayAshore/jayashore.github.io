@echo off
title Publish Hexo Blog

cd /d "%~dp0"

echo ========================================
echo          Publish Hexo Blog
echo ========================================
echo.

echo Current changes:
git status --short
echo.

set "COMMIT_MSG="
set /p "COMMIT_MSG=Commit message: "

if not defined COMMIT_MSG (
    echo.
    echo Commit message cannot be empty.
    pause
    exit /b 1
)

echo.
echo Staging files...
git add -A

rem Keep local helper scripts out of the commit.
git restore --staged -- publish-blog.bat 2>nul
git restore --staged -- publish-blog-en.bat 2>nul
git restore --staged -- publish-blog-v2.bat 2>nul
git restore --staged -- start-server.bat 2>nul
git restore --staged -- start-server-en.bat 2>nul

echo.
echo Files to be committed:
git status --short
echo.

set "CONFIRM="
set /p "CONFIRM=Commit these files? (Y/N): "
if /I not "%CONFIRM%"=="Y" (
    echo Commit cancelled.
    pause
    exit /b 0
)

echo.
echo Creating commit...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo Commit failed.
    pause
    exit /b 1
)

echo.
echo Pulling remote changes...
git pull --rebase origin main
if errorlevel 1 (
    echo Pull failed. A conflict may need to be resolved.
    echo Run: git status
    echo Then resolve files and run: git rebase --continue
    pause
    exit /b 1
)

echo.
echo Pushing to GitHub...
git push origin main
if errorlevel 1 (
    echo Push failed.
    pause
    exit /b 1
)

echo.
echo Publish completed successfully.
pause
