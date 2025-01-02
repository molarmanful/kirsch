FROM greyltc/archlinux-aur:paru AS deps

WORKDIR /app
COPY . .

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:23-jre $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"


FROM deps AS build

RUN aur-install fontforge bdfresize xfonts-bdftopcf woff2 zip

CMD ["./build.sh ${ARGS}"]


FROM deps AS img

RUN aur-install harfbuzz-utils

CMD ["./img.sh"]
