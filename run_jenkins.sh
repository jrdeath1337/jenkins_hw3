docker run \
  --name jenkins-blueocean \
  --detach \
  --network jenkins \
  --restart=on-failure \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins-data:/var/jenkins_home \
  -p 8181:8080 \
  -p 50000:50000 \
  --group-add $(stat -c '%g' /var/run/docker.sock) \
  myjenkins-blueocean:2.541.2-1
