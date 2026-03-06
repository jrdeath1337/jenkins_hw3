// Jenkinsfile – Declarative Pipeline для Python-проекта
pipeline {
    // 1. Запуск на агенте с меткой 'build-agent'
    agent { label 'jenkins_python' }

    environment {
        // Идентификатор credentials для доступа к Git (если репозиторий приватный)
        // GIT_CREDS = credentials('github-credentials')
        
        // Переменная для вывода версии Python (проверка)
        PYTHON_VERSION = 'python3'
    }

    stages {
        // 2. Получение исходного кода
        stage('Checkout') {
            steps {
                // Для публичного репозитория можно просто git url
                git url: 'git@github.com:jrdeath1337/jenkins_hw3.git', branch: 'main'
                // Если репозиторий приватный, используйте credentials:
                // git branch: 'main',
                //     url: 'git@github.com:your-username/python-calculator.git',
                //     credentialsId: 'github-credentials'
            }
        }

        // 3. Установка зависимостей
        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        // 4. Линтинг (проверка стиля кода) – опционально
        stage('Lint') {
            steps {
                sh '''
                    . venv/bin/activate
                    flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
                    flake8 . --count --exit-zero --max-complexity=10 --statistics
                '''
            }
        }

        // 5. Тестирование с генерацией отчётов
        stage('Test') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest --junitxml=reports/junit.xml --html=reports/test-report.html --self-contained-html
                '''
            }
            post {
                always {
                    // Публикация JUnit-отчёта
                    junit 'reports/junit.xml'
                    
                    // Публикация HTML-отчёта (потребуется плагин HTML Publisher)
                    publishHTML([
                      reportDir: 'reports',
                      reportFiles: 'test-report.html',
                      reportName: 'Pytest HTML Report',
                      keepAll: true,
                      allowMissing: false,           // добавлено
                      alwaysLinkToLastBuild: true    // добавлено
                    ])
                }
            }
        }

        // 6. Сборка пакета (например, создание .tar.gz)
        stage('Build Package') {
            steps {
                sh '''
                    . venv/bin/activate
                    python setup.py sdist
                '''
            }
        }

        // 7. Архивация артефактов (исходники + пакет)
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'dist/*.tar.gz', fingerprint: true
            }
        }

        // 8. Дополнительная стадия: тестирование в Docker-контейнере (гибридное окружение)
        stage('Test in Docker') {
            agent {
                docker {
                    image 'python:3.9-slim'        // официальный образ Python
                    label 'docker-host'             // метка агента с Docker (можно ту же 'build-agent', если на нём есть Docker)
                    args '-v /tmp:/tmp'             // монтирование томов при необходимости
                }
            }
            steps {
                // Внутри контейнера клонируем код (или можно использовать workspace, но проще склонировать заново)
                git url: 'https://github.com/your-username/python-calculator.git', branch: 'main'
                sh '''
                    pip install --no-cache-dir -r requirements.txt
                    pytest --junitxml=reports/docker-junit.xml
                '''
            }
            post {
                always {
                    // Публикуем отчёты из Docker-стадии (если нужно отдельно)
                    junit 'reports/docker-junit.xml'
                }
            }
        }
    }

    post {
        failure {
            // Уведомление о неудаче (например, в Telegram или email)
            echo "Pipeline failed. Check logs."
        }
        success {
            echo "Pipeline completed successfully!"
        }
    }
}
