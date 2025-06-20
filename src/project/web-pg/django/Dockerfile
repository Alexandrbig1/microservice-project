FROM python:3.10-slim

ENV APP_HOME /app

WORKDIR /app

COPY requirements.txt .

COPY requirements.txt $APP_HOME/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

ENV POSTGRES_HOST=${POSTGRES_HOST}
ENV POSTGRES_PORT=${POSTGRES_PORT}
ENV POSTGRES_NAME=${POSTGRES_NAME}
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

COPY . .

CMD ["python", "main.py", "runserver", "0.0.0.0:8000"]
