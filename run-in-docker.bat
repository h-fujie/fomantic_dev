@echo off
setlocal

cd /d "%~dp0"

rem �t�H���_�N���A
powershell -Command "Remove-Item '.\gen\out\*' -Recurse -Force -Exclude '.gitkeep'"
powershell -Command "Remove-Item '.\html\ext\*' -Recurse -Force -Exclude '.gitkeep'"

rem OpenAPI�R�[�h����
docker run --rm ^
    -v ".\gen:/gen" ^
    -v ".\swagger:/swagger" ^
    swaggerapi/swagger-codegen-cli-v3 generate ^
        -i /swagger/swagger.yaml ^
        -o /gen/out/openapi ^
        -l openapi

rem NodeJS�R�[�h����
docker run --rm ^
    -v ".\gen:/gen" ^
    -v ".\swagger:/swagger" ^
    swaggerapi/swagger-codegen-cli-v3 generate ^
        -i /gen/out/openapi/openapi.json ^
        -o /gen/out/nodejs-server ^
        -l nodejs-server

rem jQuery, Fomantic-UI�擾
docker build --file DockerfileExt --output .\html\ext .

pause

endlocal