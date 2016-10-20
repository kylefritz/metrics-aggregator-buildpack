@REM ----------------------------------------------------------------------------
@REM  Copyright 2001-2006 The Apache Software Foundation.
@REM
@REM  Licensed under the Apache License, Version 2.0 (the "License");
@REM  you may not use this file except in compliance with the License.
@REM  You may obtain a copy of the License at
@REM
@REM       http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM  Unless required by applicable law or agreed to in writing, software
@REM  distributed under the License is distributed on an "AS IS" BASIS,
@REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM  See the License for the specific language governing permissions and
@REM  limitations under the License.
@REM ----------------------------------------------------------------------------
@REM
@REM   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
@REM   reserved.

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup
set REPO=


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\lib

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\slf4j-api-1.7.12.jar;"%REPO%"\logback-classic-1.1.3.jar;"%REPO%"\logback-core-1.1.3.jar;"%REPO%"\logback-steno-1.16.0.jar;"%REPO%"\log4j-over-slf4j-1.7.12.jar;"%REPO%"\akka-slf4j_2.11-2.4.2.jar;"%REPO%"\metrics-client-0.4.5.jar;"%REPO%"\jvm-extra-0.4.2.jar;"%REPO%"\guava-18.0.jar;"%REPO%"\guice-4.0.jar;"%REPO%"\javax.inject-1.jar;"%REPO%"\aopalliance-1.0.jar;"%REPO%"\protobuf-java-3.0.0-beta-2.jar;"%REPO%"\jackson-annotations-2.7.3.jar;"%REPO%"\jackson-core-2.7.3.jar;"%REPO%"\jackson-databind-2.7.3.jar;"%REPO%"\jackson-datatype-guava-2.7.3.jar;"%REPO%"\jackson-module-guice-2.7.3.jar;"%REPO%"\jackson-datatype-jdk8-2.7.3.jar;"%REPO%"\jackson-datatype-joda-2.7.3.jar;"%REPO%"\jackson-module-afterburner-2.7.3.jar;"%REPO%"\akka-actor_2.11-2.4.2.jar;"%REPO%"\akka-http-core_2.11-2.4.2.jar;"%REPO%"\akka-parsing_2.11-2.4.2.jar;"%REPO%"\akka-stream_2.11-2.4.2.jar;"%REPO%"\ssl-config-akka_2.11-0.1.3.jar;"%REPO%"\ssl-config-core_2.11-0.1.3.jar;"%REPO%"\scala-parser-combinators_2.11-1.0.4.jar;"%REPO%"\reactive-streams-1.0.0.jar;"%REPO%"\config-1.2.1.jar;"%REPO%"\commons-1.7.1.jar;"%REPO%"\joda-time-2.8.2.jar;"%REPO%"\oval-1.86-SNAPSHOT.jar;"%REPO%"\javassist-3.20.0-GA.jar;"%REPO%"\javassist-maven-core-0.1.2.jar;"%REPO%"\jsr305-3.0.0.jar;"%REPO%"\findbugs-annotations-3.0.1.jar;"%REPO%"\scala-library-2.11.7.jar;"%REPO%"\scala-java8-compat_2.11-0.7.0.jar;"%REPO%"\vertx-core-2.1.6.jar;"%REPO%"\netty-all-4.0.21.Final.jar;"%REPO%"\log4j-1.2.16.jar;"%REPO%"\httpclient-4.5.1.jar;"%REPO%"\commons-logging-1.2.jar;"%REPO%"\httpcore-4.4.3.jar;"%REPO%"\commons-io-2.4.jar;"%REPO%"\commons-codec-1.10.jar;"%REPO%"\reflections-0.9.10.jar;"%REPO%"\annotations-2.0.1.jar;"%REPO%"\aspectjrt-1.8.9.jar;"%REPO%"\cglib-3.2.1.jar;"%REPO%"\asm-5.0.3.jar;"%REPO%"\ant-1.9.4.jar;"%REPO%"\ant-launcher-1.9.4.jar;"%REPO%"\metrics-aggregator-protocol-1.0.3.jar;"%REPO%"\metrics-aggregator-daemon-1.1.0.jar

set ENDORSED_DIR=lib/ext
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%"\%ENDORSED_DIR%\*;%CLASSPATH%

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS%  -classpath %CLASSPATH% -Dapp.name="mad" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" com.arpnetworking.metrics.mad.Main %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@REM If error code is set to 1 then the endlocal was done already in :error.
if %ERROR_CODE% EQU 0 @endlocal


:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
