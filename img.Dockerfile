FROM greyltc/archlinux-aur:paru AS deps
WORKDIR /app

RUN aur-install harfbuzz-utils

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:23-jre $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"


FROM deps
COPY . .
CMD ["./img.sh"]
