FROM python:3.10-alphine

WORKDIR /app

COPY  backend/ /app/

RUN pip install flask -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
