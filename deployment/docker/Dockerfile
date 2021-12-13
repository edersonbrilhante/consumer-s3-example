
FROM python:3.9.4-slim AS build

RUN python3 -m pip install poetry
COPY poetry.lock pyproject.toml ./
RUN poetry export --without-hashes -o /opt/requirements.txt


FROM python:3.9.4-slim

COPY --from=build /opt/requirements.txt .
RUN apt-get update
RUN apt-get install jq -y
RUN pip install -r requirements.txt
RUN pip install awscli

WORKDIR /app
COPY deployment/docker/docker-entrypoint.sh  ./

COPY app /app
CMD ["./docker-entrypoint.sh"]
