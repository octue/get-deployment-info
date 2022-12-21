FROM python:3.10.7-slim

RUN apt-get update -y && apt-get install -y --fix-missing curl && rm -rf /var/lib/apt/lists/*

# Install poetry.
ENV POETRY_HOME=/root/.poetry
ENV PATH "$POETRY_HOME/bin:$PATH"
RUN curl -sSL https://install.python-poetry.org | python3 - && poetry config virtualenvs.create false;

COPY get_deployment_info/entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
