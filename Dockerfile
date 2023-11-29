FROM python:3.10.7-slim

RUN apt-get update -y && apt-get install -y --fix-missing curl git && rm -rf /var/lib/apt/lists/*

RUN pip3 install git+https://github.com/octue/get-deployment-info@facilitate-branch-deployments

COPY get_deployment_info/entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
