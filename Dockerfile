FROM python:alpine AS builder

WORKDIR /app

COPY requirements.txt .

RUN  pip install --user --no-cache-dir -r requirements.txt

FROM python:alpine

RUN adduser -D myuser

USER myuser

WORKDIR /home/myuser/app


COPY --from=builder --chown=myuser:myuser /root/.local /home/myuser/app/.local


COPY --chown=myuser:myuser  /app .

ENV path=/home/myuser/app/.local/bin:$PATH

HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000'); exit(0)"
 

EXPOSE 5000

CMD ["python","app.py"]
