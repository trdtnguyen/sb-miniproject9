FROM python:3.6

WORKDIR /usr/app

ADD ./requirements.txt ./
RUN pip install -r requirements.txt
ADD ./ ./
RUN export PYTHONPATH=$PYTHONPATH;.

CMD ["python", "app.py"]
