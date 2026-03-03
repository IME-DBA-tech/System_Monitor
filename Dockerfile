FROM python:slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*


COPY app/requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:slim

RUN useradd -m myuser
USER myuser

WORKDIR /home/myuser/app


COPY --from=builder /install /usr/local


COPY --chown=myuser:myuser  /app .



HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000'); exit(0)"
 

EXPOSE 5000


CMD ["python","app.py"]
