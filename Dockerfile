# Используем официальный образ JNLP-агента
FROM jenkins/inbound-agent:alpine-jdk21

# Переключаемся на root для установки пакетов
USER root

# Установка Python 3, pip и необходимых зависимостей
RUN apk add --no-cache \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

# Переключаемся обратно на пользователя jenkins
USER jenkins

# Проверка установки
RUN python3 --version && pip3 --version
