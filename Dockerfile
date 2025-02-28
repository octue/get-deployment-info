FROM python:3.10.7-slim

RUN apt-get update -y && apt-get install -y --fix-missing curl git && rm -rf /var/lib/apt/lists/*

RUN pip install "poetry>=2,<3"

COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
