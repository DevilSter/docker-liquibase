
docker build -f Dockerfile --build-arg LB_VER=3.1.1 -t evangistudio/liquibase:3.1 .

Для Общей инфы 
docker run --rm  evangistudio/liquibase:3.1 liquibase --version

Запуск

Expecting the changelog.xml is inside the current directory the update process can be started with: 

docker run --rm -v $(pwd):/migrations/ \
        -e "LB_URL=jdbc:postgresql://host:5432/sampledb" \
        -e "LB_USER=root" \
        -e "LB_PASS=root" \        
        evangistudio/liquibase:3.1 update
        
Другие доступные переменные 

