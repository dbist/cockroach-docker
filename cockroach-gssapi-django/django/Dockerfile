FROM python:3.8-alpine
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.3"
ENV REFRESHED_AT 2020_08_04
ENV PYTHONUNBUFFERED 1
RUN mkdir code
COPY requirements.txt code/
WORKDIR code
RUN apk update && apk add --no-cache postgresql-dev gcc python3-dev musl-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk add --no-cache krb5 libpq \
    && rm -rf /var/cache/apk/*
#RUN tail /dev/null

COPY start.sh code/
#ENTRYPOINT ["start.sh"]
CMD ["start.sh"]
