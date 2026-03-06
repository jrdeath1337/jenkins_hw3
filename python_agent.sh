docker run -d \
--name jenkins_python \
--env-file ./.env \
--network jenkins \
python_agent:v1
