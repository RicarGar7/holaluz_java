FROM maven:3.8.2-jdk-11 as build

WORKDIR /app

COPY . .

RUN mvn package -DskipTests

RUN mkdir -p /build/extracted
RUN java -Djarmode=layertools -jar cli/target/*.jar extract --destination /build/extracted
FROM openjdk:17-alpine
ARG EXTRACTED=/build/extracted

VOLUME /tmp

COPY docker/entrypoint.sh /usr/local/bin/
COPY docker/holaluz.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/holaluz.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]

RUN addgroup -S bkpsystem && adduser -S bkpsystem -G bkpsystem
USER bkpsystem:bkpsystem
WORKDIR /home/bkpsystem

COPY --from=build ${EXTRACTED}/dependencies/ ./
COPY --from=build ${EXTRACTED}/spring-boot-loader/ ./
COPY --from=build ${EXTRACTED}/snapshot-dependencies/ ./
# https://github.com/moby/moby/issues/37965#issuecomment-426853382
RUN true
COPY --from=build ${EXTRACTED}/application/ ./

COPY --from=build /app/cli/target/*jar ./cli/
RUN alias holaluz='java -jar $HOME/cli/*jar'

CMD ["java", "org.springframework.boot.loader.JarLauncher"]