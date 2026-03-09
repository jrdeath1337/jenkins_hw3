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
        // 3. Установка зависимостей
        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install setuptools wheel
                    pip install -r requirements.txt
                '''
            }
        }

        // 4. Линтинг (проверка стиля кода) – опционально
        stage('Lint') {
            steps {
                sh '''
                    . venv/bin/activate
                    flake8 . --exclude=venv,.git,__pycache__ --count --select=E9,F63,F7,F82 --show-source --statistics
                    flake8 . --exclude=venv,.git,__pycache__ --count --exit-zero --max-complexity=10 --statistics
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
}
