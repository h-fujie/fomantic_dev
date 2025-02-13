@echo off
setlocal

cd /d "%~dp0"

rem フォルダクリア
powershell -Command "Remove-Item '.\gen\out\*' -Recurse -Force -Exclude '.gitkeep'"
powershell -Command "Remove-Item '.\html\ext\*' -Recurse -Force -Exclude '.gitkeep'"

rem OpenAPIコード生成
docker run --rm ^
    -v ".\gen:/gen" ^
    -v ".\swagger:/swagger" ^
    swaggerapi/swagger-codegen-cli-v3 generate ^
        -i /swagger/swagger.yaml ^
        -o /gen/out/openapi ^
        -l openapi

rem NodeJSコード生成
docker run --rm ^
    -v ".\gen:/gen" ^
    -v ".\swagger:/swagger" ^
    swaggerapi/swagger-codegen-cli-v3 generate ^
        -i /gen/out/openapi/openapi.json ^
        -o /gen/out/nodejs-server ^
        -l nodejs-server

rem jQuery, Fomantic-UI取得
docker build --file DockerfileExt --output .\html\ext .

pause

endlocal