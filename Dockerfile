FROM python:3.8.1-alpine3.11


ENV PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.0.3 \
  # This prevents Python from writing out pyc files \
  PYTHONDONTWRITEBYTECODE=1 \
  # This keeps Python from buffering stdin/stdout \
  PYTHONUNBUFFERED=1 \
  PYTHONPATH=/code

WORKDIR /code

# Upadate Apline Linux and install system packages
# build-base - C and C++ compiliers needs for some python packages
# python-dev - Needed for building C extensions for CPython
# postgresql-dev - Contains the header files needed for installing psycopg2-binary
# libffi-dev - Needed for crytography packages like bcrypt
RUN apk update \
    && apk add build-base python-dev postgresql-dev libffi-dev linux-headers

# Install Python packages
COPY poetry.lock pyproject.toml ./

RUN set -ex \
    && pip install --upgrade pip \
    && pip install "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi
