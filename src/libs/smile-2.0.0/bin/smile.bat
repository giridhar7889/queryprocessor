@REM smile launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM SMILE_config.txt found in the SMILE_HOME.
@setlocal enabledelayedexpansion
@setlocal enableextensions

@echo off


if "%SMILE_HOME%"=="" (
  set "APP_HOME=%~dp0\\.."

  rem Also set the old env name for backwards compatibility
  set "SMILE_HOME=%~dp0\\.."
) else (
  set "APP_HOME=%SMILE_HOME%"
)

set "APP_LIB_DIR=%APP_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%APP_HOME%\SMILE_config.txt"
set CFG_OPTS=
call :parse_config "%CFG_FILE%" CFG_OPTS

rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

set "APP_CLASSPATH=%APP_LIB_DIR%\com.github.haifengl.smile-shell-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-benchmark-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-core-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-data-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-math-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-graph-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-netlib-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-scala-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-io-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-interpolation-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-nlp-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-plot-2.0.0.jar;%APP_LIB_DIR%\com.github.haifengl.smile-demo-2.0.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.13.1.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.26.jar;%APP_LIB_DIR%\com.github.fommil.netlib.core-1.1.2.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_ref-osx-x86_64-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.native_ref-java-1.1.jar;%APP_LIB_DIR%\com.github.fommil.jniloader-1.1.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_ref-linux-x86_64-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_ref-linux-i686-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_ref-win-x86_64-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_ref-win-i686-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_ref-linux-armhf-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_system-osx-x86_64-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.native_system-java-1.1.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_system-linux-x86_64-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_system-linux-i686-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_system-linux-armhf-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_system-win-x86_64-1.1-natives.jar;%APP_LIB_DIR%\com.github.fommil.netlib.netlib-native_system-win-i686-1.1-natives.jar;%APP_LIB_DIR%\net.sourceforge.f2j.arpack_combined_all-0.1.jar;%APP_LIB_DIR%\org.apache.arrow.arrow-memory-0.11.0.jar;%APP_LIB_DIR%\com.google.code.findbugs.jsr305-3.0.2.jar;%APP_LIB_DIR%\io.netty.netty-buffer-4.1.22.Final.jar;%APP_LIB_DIR%\io.netty.netty-common-4.1.22.Final.jar;%APP_LIB_DIR%\org.apache.arrow.arrow-vector-0.11.0.jar;%APP_LIB_DIR%\org.apache.arrow.arrow-format-0.11.0.jar;%APP_LIB_DIR%\com.google.flatbuffers.flatbuffers-java-1.9.0.jar;%APP_LIB_DIR%\joda-time.joda-time-2.9.9.jar;%APP_LIB_DIR%\com.carrotsearch.hppc-0.7.2.jar;%APP_LIB_DIR%\org.apache.parquet.parquet-hadoop-1.10.0.jar;%APP_LIB_DIR%\org.apache.parquet.parquet-column-1.10.0.jar;%APP_LIB_DIR%\org.apache.parquet.parquet-common-1.10.0.jar;%APP_LIB_DIR%\org.apache.parquet.parquet-format-2.4.0.jar;%APP_LIB_DIR%\org.apache.parquet.parquet-encoding-1.10.0.jar;%APP_LIB_DIR%\org.apache.parquet.parquet-jackson-1.10.0.jar;%APP_LIB_DIR%\org.codehaus.jackson.jackson-mapper-asl-1.9.13.jar;%APP_LIB_DIR%\org.codehaus.jackson.jackson-core-asl-1.9.13.jar;%APP_LIB_DIR%\org.xerial.snappy.snappy-java-1.1.2.6.jar;%APP_LIB_DIR%\commons-pool.commons-pool-1.6.jar;%APP_LIB_DIR%\org.apache.hadoop.hadoop-common-3.2.1.jar;%APP_LIB_DIR%\org.apache.hadoop.hadoop-annotations-3.2.1.jar;%APP_LIB_DIR%\com.google.guava.guava-27.0-jre.jar;%APP_LIB_DIR%\com.google.guava.failureaccess-1.0.jar;%APP_LIB_DIR%\com.google.guava.listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar;%APP_LIB_DIR%\org.checkerframework.checker-qual-2.5.2.jar;%APP_LIB_DIR%\com.google.errorprone.error_prone_annotations-2.2.0.jar;%APP_LIB_DIR%\com.google.j2objc.j2objc-annotations-1.1.jar;%APP_LIB_DIR%\org.codehaus.mojo.animal-sniffer-annotations-1.17.jar;%APP_LIB_DIR%\commons-cli.commons-cli-1.2.jar;%APP_LIB_DIR%\org.apache.commons.commons-math3-3.1.1.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpclient-4.5.6.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpcore-4.4.10.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.1.3.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.11.jar;%APP_LIB_DIR%\commons-io.commons-io-2.5.jar;%APP_LIB_DIR%\commons-net.commons-net-3.6.jar;%APP_LIB_DIR%\commons-collections.commons-collections-3.2.2.jar;%APP_LIB_DIR%\javax.servlet.javax.servlet-api-3.1.0.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-server-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-http-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-util-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-io-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-servlet-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-security-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-webapp-9.3.24.v20180605.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-xml-9.3.24.v20180605.jar;%APP_LIB_DIR%\com.sun.jersey.jersey-core-1.19.jar;%APP_LIB_DIR%\javax.ws.rs.jsr311-api-1.1.1.jar;%APP_LIB_DIR%\com.sun.jersey.jersey-servlet-1.19.jar;%APP_LIB_DIR%\com.sun.jersey.jersey-json-1.19.jar;%APP_LIB_DIR%\org.codehaus.jettison.jettison-1.1.jar;%APP_LIB_DIR%\com.sun.xml.bind.jaxb-impl-2.2.3-1.jar;%APP_LIB_DIR%\javax.xml.bind.jaxb-api-2.2.2.jar;%APP_LIB_DIR%\javax.xml.stream.stax-api-1.0-2.jar;%APP_LIB_DIR%\javax.activation.activation-1.1.jar;%APP_LIB_DIR%\org.codehaus.jackson.jackson-jaxrs-1.9.2.jar;%APP_LIB_DIR%\org.codehaus.jackson.jackson-xc-1.9.2.jar;%APP_LIB_DIR%\com.sun.jersey.jersey-server-1.19.jar;%APP_LIB_DIR%\log4j.log4j-1.2.17.jar;%APP_LIB_DIR%\commons-beanutils.commons-beanutils-1.9.3.jar;%APP_LIB_DIR%\org.apache.commons.commons-configuration2-2.1.1.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.7.jar;%APP_LIB_DIR%\org.apache.commons.commons-text-1.4.jar;%APP_LIB_DIR%\org.apache.avro.avro-1.8.2.jar;%APP_LIB_DIR%\com.thoughtworks.paranamer.paranamer-2.7.jar;%APP_LIB_DIR%\org.apache.commons.commons-compress-1.18.jar;%APP_LIB_DIR%\org.tukaani.xz-1.5.jar;%APP_LIB_DIR%\com.google.re2j.re2j-1.1.jar;%APP_LIB_DIR%\com.google.protobuf.protobuf-java-2.5.0.jar;%APP_LIB_DIR%\com.google.code.gson.gson-2.2.4.jar;%APP_LIB_DIR%\org.apache.hadoop.hadoop-auth-3.2.1.jar;%APP_LIB_DIR%\com.nimbusds.nimbus-jose-jwt-4.41.1.jar;%APP_LIB_DIR%\com.github.stephenc.jcip.jcip-annotations-1.0-1.jar;%APP_LIB_DIR%\net.minidev.json-smart-2.3.jar;%APP_LIB_DIR%\net.minidev.accessors-smart-1.2.jar;%APP_LIB_DIR%\org.ow2.asm.asm-5.0.4.jar;%APP_LIB_DIR%\org.apache.zookeeper.zookeeper-3.4.13.jar;%APP_LIB_DIR%\org.apache.yetus.audience-annotations-0.5.0.jar;%APP_LIB_DIR%\io.netty.netty-3.10.6.Final.jar;%APP_LIB_DIR%\org.apache.curator.curator-framework-2.13.0.jar;%APP_LIB_DIR%\org.apache.curator.curator-client-2.13.0.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-simplekdc-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-client-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerby-config-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-core-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerby-pkix-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerby-asn1-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerby-util-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-common-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-crypto-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-util-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.token-provider-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-admin-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-server-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerb-identity-1.0.1.jar;%APP_LIB_DIR%\org.apache.kerby.kerby-xdr-1.0.1.jar;%APP_LIB_DIR%\com.jcraft.jsch-0.1.54.jar;%APP_LIB_DIR%\org.apache.curator.curator-recipes-2.13.0.jar;%APP_LIB_DIR%\org.apache.htrace.htrace-core4-4.1.0-incubating.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.9.8.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.9.0.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.9.8.jar;%APP_LIB_DIR%\org.codehaus.woodstox.stax2-api-3.1.4.jar;%APP_LIB_DIR%\com.fasterxml.woodstox.woodstox-core-5.0.3.jar;%APP_LIB_DIR%\dnsjava.dnsjava-2.1.7.jar;%APP_LIB_DIR%\javax.servlet.jsp.jsp-api-2.1.jar;%APP_LIB_DIR%\com.epam.parso-2.0.10.jar;%APP_LIB_DIR%\org.apache.commons.commons-csv-1.6.jar;%APP_LIB_DIR%\org.swinglabs.swingx-1.6.1.jar;%APP_LIB_DIR%\com.jhlabs.filters-2.0.235.jar;%APP_LIB_DIR%\org.swinglabs.swing-worker-1.1.jar;%APP_LIB_DIR%\com.thoughtworks.xstream.xstream-1.4.11.1.jar;%APP_LIB_DIR%\xmlpull.xmlpull-1.1.3.1.jar;%APP_LIB_DIR%\xpp3.xpp3_min-1.1.4c.jar;%APP_LIB_DIR%\com.typesafe.scala-logging.scala-logging_2.13-3.9.2.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.13.1.jar;%APP_LIB_DIR%\org.slf4j.slf4j-simple-1.7.26.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite_2.13.1-1.7.4.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-terminal_2.13-1.7.4.jar;%APP_LIB_DIR%\com.lihaoyi.sourcecode_2.13-0.1.7.jar;%APP_LIB_DIR%\com.lihaoyi.fansi_2.13-0.2.7.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-ops_2.13-1.7.4.jar;%APP_LIB_DIR%\com.lihaoyi.os-lib_2.13-0.3.0.jar;%APP_LIB_DIR%\com.lihaoyi.geny_2.13-0.1.8.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-collection-compat_2.13-2.0.0.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-util_2.13-1.7.4.jar;%APP_LIB_DIR%\com.lihaoyi.pprint_2.13-0.5.5.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-runtime_2.13.1-1.7.4.jar;%APP_LIB_DIR%\com.lihaoyi.upickle_2.13-0.8.0.jar;%APP_LIB_DIR%\com.lihaoyi.ujson_2.13-0.8.0.jar;%APP_LIB_DIR%\com.lihaoyi.upickle-core_2.13-0.8.0.jar;%APP_LIB_DIR%\com.lihaoyi.upack_2.13-0.8.0.jar;%APP_LIB_DIR%\com.lihaoyi.upickle-implicits_2.13-0.8.0.jar;%APP_LIB_DIR%\com.lihaoyi.requests_2.13-0.2.0.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-interp-api_2.13.1-1.7.4.jar;%APP_LIB_DIR%\org.scala-lang.scala-compiler-2.13.1.jar;%APP_LIB_DIR%\jline.jline-2.14.6.jar;%APP_LIB_DIR%\org.fusesource.jansi.jansi-1.12.jar;%APP_LIB_DIR%\io.get-coursier.interface-0.0.8.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-repl-api_2.13.1-1.7.4.jar;%APP_LIB_DIR%\com.github.scopt.scopt_2.13-3.7.1.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-interp_2.13.1-1.7.4.jar;%APP_LIB_DIR%\com.lihaoyi.scalaparse_2.13-2.1.3.jar;%APP_LIB_DIR%\com.lihaoyi.fastparse_2.13-2.1.3.jar;%APP_LIB_DIR%\org.javassist.javassist-3.21.0-GA.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-xml_2.13-1.2.0.jar;%APP_LIB_DIR%\com.lihaoyi.ammonite-repl_2.13.1-1.7.4.jar;%APP_LIB_DIR%\org.jline.jline-terminal-3.6.2.jar;%APP_LIB_DIR%\org.jline.jline-terminal-jna-3.6.2.jar;%APP_LIB_DIR%\net.java.dev.jna.jna-4.2.2.jar;%APP_LIB_DIR%\org.jline.jline-reader-3.6.2.jar;%APP_LIB_DIR%\com.github.javaparser.javaparser-core-3.2.5.jar"
set "APP_MAIN_CLASS=smile.shell.Main"
set "SCRIPT_CONF_FILE=%APP_HOME%\conf\application.ini"

rem Bundled JRE has priority over standard environment variables
if defined BUNDLED_JVM (
  set "_JAVACMD=%BUNDLED_JVM%\bin\java.exe"
) else (
  if "%JAVACMD%" neq "" (
    set "_JAVACMD=%JAVACMD%"
  ) else (
    if "%JAVA_HOME%" neq "" (
      if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
    )
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running smile.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)

rem if configuration files exist, prepend their contents to the script arguments so it can be processed by this runner
call :parse_config "%SCRIPT_CONF_FILE%" SCRIPT_CONF_ARGS

call :process_args %SCRIPT_CONF_ARGS% %%*

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!

if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !SMILE_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!

@endlocal

exit /B %ERRORLEVEL%


rem Loads a configuration file full of default command line options for this script.
rem First argument is the path to the config file.
rem Second argument is the name of the environment variable to write to.
:parse_config
  set _PARSE_FILE=%~1
  set _PARSE_OUT=
  if exist "%_PARSE_FILE%" (
    FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%_PARSE_FILE%") DO (
      set _PARSE_OUT=!_PARSE_OUT! %%i
    )
  )
  set %2=!_PARSE_OUT!
exit /B 0


:add_java
  set _JAVA_PARAMS=!_JAVA_PARAMS! %*
exit /B 0


:add_app
  set _APP_ARGS=!_APP_ARGS! %*
exit /B 0


rem Processes incoming arguments and places them in appropriate global variables
:process_args
  :param_loop
  call set _PARAM1=%%1
  set "_TEST_PARAM=%~1"

  if ["!_PARAM1!"]==[""] goto param_afterloop


  rem ignore arguments that do not start with '-'
  if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
  set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  shift
  goto param_loop

  :param_java_check
  if "!_TEST_PARAM:~0,2!"=="-J" (
    rem strip -J prefix
    set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
    shift
    goto param_loop
  )

  if "!_TEST_PARAM:~0,2!"=="-D" (
    rem test if this was double-quoted property "-Dprop=42"
    for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
      if not ["%%H"] == [""] (
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      ) else if [%2] neq [] (
        rem it was a normal property: -Dprop=42 or -Drop="42"
        call set _PARAM1=%%1=%%2
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
        shift
      )
    )
  ) else (
    if "!_TEST_PARAM!"=="-main" (
      call set CUSTOM_MAIN_CLASS=%%2
      shift
    ) else (
      set _APP_ARGS=!_APP_ARGS! !_PARAM1!
    )
  )
  shift
  goto param_loop
  :param_afterloop

exit /B 0
