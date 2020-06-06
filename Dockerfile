## Input 폴더는 볼륨 마운트해서 호스트에서 이미지 추출 진행
FROM ubuntu:16.04
WORKDIR /root

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PROJ_NAME=static-protocol-264107

COPY ./*.py /root/ 
COPY ./credential_key.json /root/credential_key.json

RUN apt-get -y update && apt-get -y install python3 python3-pip curl 
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

RUN gcloud auth activate-service-account --key-file=credential_key.json && gcloud config set project $PROJ_NAME

RUN pip3 install --upgrade pip && pip3 install --upgrade google-cloud-storage && pip3 install --upgrade google-cloud-speech && pip3 install flask flask_cors


RUN gcloud auth activate-service-account --key-file credential_key.json
ENV GOOGLE_APPLICATION_CREDENTIALS="/root/credential_key.json"

COPY input /root/input
ENTRYPOINT [ "flask", "run" , "--host",  "0.0.0.0"]
