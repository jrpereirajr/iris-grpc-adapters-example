"""
The Python implementation of the GRPC helloworld.Greeter client.
Adapted from:
    - https://github.com/grpc/grpc/blob/master/examples/python/helloworld/async_greeter_client.py
    - https://github.com/grpc/grpc/blob/master/examples/python/hellostreamingworld/async_greeter_client.py
"""

import logging
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

import grpc
from helloworld_pb2 import HelloRequest
from helloworld_pb2_grpc import MultiGreeterStub

import names

# from client_interceptor import ClientInterceptor

parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
parser.add_argument("-p", "--port", default="50051", help="Server port")
args = vars(parser.parse_args())

def run() -> None:
    port = args["port"]
    channel = grpc.insecure_channel(f'localhost:{port}')
    # intercept_channel = grpc.intercept_channel(channel, ClientInterceptor())
    intercept_channel = grpc.intercept_channel(channel)
    stub = MultiGreeterStub(intercept_channel)

    response = stub.SayHello(HelloRequest(name=names.get_full_name()))
    print("Greeter client received: " + response.message)
    
    for response in stub.SayHelloStream(HelloRequest(name=names.get_full_name())):
        print("Greeter client received from stream: " + response.message)

logging.basicConfig(level=logging.INFO)
# run()

from threading import Thread
for x in range(0,1):
    x = Thread(target=run, args=(), daemon=False)
    x.start()