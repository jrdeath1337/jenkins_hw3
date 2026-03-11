## Python Calculator CI/CD Pipeline
Этот проект демонстрирует настройку непрерывной интеграции и доставки (CI/CD) для простого Python-приложения (калькулятор) с использованием Jenkins. Pipeline автоматизирует установку зависимостей, линтинг, тестирование, сборку пакета и архивацию артефактов при каждом пуше в репозиторий.

## 📋Содержание
Требования

Структура репозитория

Настройка Jenkins

Подготовка агента

Установка плагинов

Настройка credentials

Создание pipeline

Описание pipeline

Стадии сборки

Отчётность

Безопасность

Запуск и результаты

Автор

## Требования
Jenkins (основной сервер) версии 2.387 или выше

Агент Jenkins с меткой jenkins_python (может быть тот же сервер или отдельная машина)

На агенте должны быть установлены:

Python 3.6+

pip

git

Плагины Jenkins:

Pipeline

Git

JUnit

HTML Publisher

Credentials Binding

SSH Credentials (если используется SSH-подключение к агенту)

## Структура репозитория
.
├── Jenkinsfile              # Declarative Pipeline
├── calculator.py            # Основной модуль калькулятора
├── test_calculator.py       # Модуль с тестами (pytest)
├── requirements.txt         # Зависимости Python
├── setup.py                 # Файл сборки пакета
└── README.md                # Документация
## Настройка Jenkins
Подготовка агента

В Jenkins перейдите в Manage Jenkins → Manage Nodes and Clouds → New Node.

Создайте узел с именем jenkins_python (или другим, но тогда измените метку в Jenkinsfile).

Укажите:

Launch method: Launch agents via SSH (рекомендуется для безопасности) или Launch agent by connecting it to the master (JNLP).

Host: IP-адрес или домен агента.

Credentials: Добавьте SSH-ключ (тип SSH Username with private key) для подключения.

Availability: Keep this agent online as much as possible.

Сохраните. Убедитесь, что агент онлайн.

## Установка плагинов
Установите необходимые плагины через Manage Jenkins → Manage Plugins → Available:

Pipeline

Git

JUnit

HTML Publisher

(по желанию) Docker Pipeline, если планируется использовать контейнеры.

## Настройка credentials
Если репозиторий приватный, добавьте credentials для доступа к GitHub/GitLab:

Manage Jenkins → Manage Credentials → (выберите область) → Add Credentials.

Тип: SSH Username with private key (или Username with password).

Укажите ID (например, github-ssh-key) и сам ключ.

## Создание pipeline
В Jenkins выберите New Item, введите имя (например, python-calculator), выберите Pipeline.

В разделе Pipeline выберите:

Definition: Pipeline script from SCM

SCM: Git

Repository URL: git@github.com:jrdeath1337/jenkins_hw3.git (или ваш URL)

Credentials: выберите ранее созданные (если репозиторий приватный)

Branches to build: */main

Script Path: Jenkinsfile

В разделе Build Triggers отметьте GitHub hook trigger for GITScm polling (если используется webhook).

Сохраните.

## Описание pipeline
Стадии сборки
Стадия	Действие
Install Dependencies	Создаётся виртуальное окружение Python, обновляется pip, устанавливаются setuptools, wheel и зависимости из requirements.txt.
Lint	Проверка стиля кода с помощью flake8. Исключаются каталоги venv, .git, __pycache__. Выводятся ошибки, но сборка не прерывается (используется --exit-zero).
Test	Запуск тестов через pytest с генерацией JUnit XML и HTML-отчёта.
Build Package	Сборка дистрибутива (tar.gz) с помощью python setup.py sdist.
Archive	Сохранение собранного пакета как артефакт сборки в Jenkins.
Отчётность
JUnit: результаты тестов публикуются и отображаются в виде графиков и истории.

HTML Publisher: создаётся отдельная вкладка с красивым HTML-отчётом о тестировании (генерируется pytest-html).

## Безопасность
Агент подключается к мастеру по SSH с использованием ключа (настройка в Jenkins).

Пользователь, от которого запускается агент, имеет минимально необходимые права (не root).

Доступ к репозиторию осуществляется через SSH-ключ, хранящийся в Jenkins Credentials.

Все секреты (ключи, пароли) не выводятся в лог сборки.

## Запуск и результаты
После настройки webhook или ручного запуска сборка стартует автоматически.

На странице сборки можно наблюдать выполнение стадий в реальном времени.

По окончании:

В разделе Test Result доступен JUnit-отчёт.

Вкладка Pytest HTML Report содержит HTML-отчёт.

В Workspace или Артефакты можно найти собранный пакет (dist/*.tar.gz).

При ошибке сборки в логах будет сообщение, а в Console Output – детали.

## Автор
Dmitriy Petrovich 
mail: jedeath1337@gmail.com
Репозиторий: github.com/jrdeath1337/jenkins_hw3
