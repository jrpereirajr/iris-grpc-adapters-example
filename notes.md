# notes

## refs projs

https://github.com/intersystems-community/pex-demo
https://github.com/jrpereirajr/pex-python-demo
https://github.com/jrpereirajr/iris-grpc-example
https://github.com/grongierisc/interoperability-embedded-python

## commands
python3 -m grpc_tools.protoc -I ./ --python_out=. --pyi_out=. --grpc_python_out=. ./route_guide.proto

cd ~/irisdev/python/src/grpc_hello_world
python3 greeter_server.py

cd ~/irisdev/python/src/grpc_hello_world
python3 greeter_client.py

cd ~/irisdev/python/src/route_guide
python3 route_guide_server.py

cd ~/irisdev/python/src/route_guide
python3 route_guide_client.py

docker exec -it iris-grpc-adapters-example-iris-1 bash

cd ~/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/

source /usr/irissys/dev/python/virtual/%Python\ Server_3252368016/bin/activate

pip3 install grpcio grpcio-tools names

python3 greeter_server_iris_adapterless.py

netstat -ltnp | grep 5005

## IRIS Python Shell

/usr/irissys/bin/irispython

## python gateway env
root@3b9972a2cd94:/home/irisowner/irisdev/python/src# ls /usr/irissys/dev/python/virtual/%Python\ Server_3252368016/lib/python3.10/site-packages/iris/pex/
_BusinessHost.py       _BusinessService.py  _IRISBusinessOperation.py  _IRISOutboundAdapter.py  _OutboundAdapter.py
_BusinessOperation.py  _Common.py           _IRISBusinessService.py    _InboundAdapter.py       __init__.py
_BusinessProcess.py    _Director.py         _IRISInboundAdapter.py     _Message.py              __pycache__

nano /usr/irissys/dev/python/runpython.sh

https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/
irisowner@2485b142cea3:~$ source /usr/irissys/dev/python/virtual/%Python\ Server_3252368016/bin/activate
(%Python Server_3252368016) irisowner@2485b142cea3:~$ pip3 install grpcio grpcio-tools

import sys
path = "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/pex/"
sys.path.append(path)
from hello_world_message import HelloRequestMessage
from helloworld_pb2 import HelloRequest
msg = HelloRequestMessage()
msg.value = HelloRequest(name="Jose")

## passos para fazer funcionar o BO do helloworld

1) instale o venv do python
apt-get update
apt-get install python3-venv

2) suba o python gateway

3) acesse o venv
source /usr/irissys/dev/python/virtual/%Python\ Server_3252368016/bin/activate

4) instale os pacotes
pip3 install grpcio grpcio-tools names

5) rode o servidor do helloworld
cd ~/irisdev/python/src/grpc_hello_world
python3 greeter_server.py

6) rode o client do helloworld
cd ~/irisdev/python/src/grpc_hello_world
python3 greeter_client.py

7) compile as classes do pacote dc/jrpereira/grpc/pex

8) rode a produção do helloworld

## interceptors
https://adityamattos.com/grpc-in-python-part-4-interceptors
https://github.com/theundeadmonk/python-grpc-demo/tree/main/python_grpc_demo
https://grpc-interceptor.readthedocs.io/en/latest/#