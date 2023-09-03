ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

USER root

RUN apt-get update && apt-get install -y python3-venv nano

USER irisowner

WORKDIR /home/irisowner/irisdev

## Python stuff
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "USER"

# ENV GRPC_VERBOSITY "DEBUG"
# ENV GRPC_TRACE "all"

ENV PYTHON_PATH=/usr/irissys/bin/
ENV LD_LIBRARY_PATH=${ISC_PACKAGE_INSTALLDIR}/bin:${LD_LIBRARY_PATH}

ENV PATH "/home/irisowner/.local/bin:/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin"

# run iris and initial 
RUN --mount=type=bind,src=.,dst=. \
    pip3 install -r requirements.txt && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly