### Start app

- Spring
    - Run CliApplication with springboot
- Maven & Java
    - mvn package -DskipTests
    - java -jar cli/target/cli.jar
- Docker
    - Build and run the dockerfile
        - Docker build -t holaluz .
        - Docker run holaluz:latest

### Cli commands

- `echo 2016-readings.xml`
- `echo 2016-readings.csv`

### Stack

- Java 17
- Springboot 2.7.3