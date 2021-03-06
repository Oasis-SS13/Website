# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-dev default-libmysqlclient-dev build-essential

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN apt-get autoremove build-essential --purge -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache

COPY server-conf/beesite_uwsgi.ini /etc/uwsgi/uwsgi.ini

WORKDIR /beesite
COPY /src /beesite

EXPOSE 8000

CMD ["/usr/local/bin/uwsgi", "--ini", "/etc/uwsgi/uwsgi.ini"]
