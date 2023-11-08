# Use an official Python runtime as a parent image
FROM --platform=$TARGETPLATFORM python:3.11-slim-bookworm

ARG TARGETARCH

# Set the working directory in the container
WORKDIR /app

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TARGETARCH} /sbin/tini
RUN chmod +x /sbin/tini

ADD entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Add current directory code to docker
ADD https://github.com/p0n1/epub_to_audiobook/raw/main/requirements.txt /app/requirements.txt
ADD https://github.com/p0n1/epub_to_audiobook/raw/main/epub_to_audiobook.py /app/epub2audiobook.py

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/sbin/tini", "--", "/app/entrypoint.sh"]
