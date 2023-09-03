"""
The Python implementation of the GRPC helloworld.Greeter server.
Adapted from:
    - https://github.com/grpc/grpc/blob/master/examples/python/helloworld/async_greeter_server.py
    - https://github.com/grpc/grpc/blob/master/examples/python/hellostreamingworld/async_greeter_server.py
    - https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3

IRIS:
    - https://community.intersystems.com/post/calling-production-rest-broker
"""

from concurrent import futures
import logging
import signal
from typing import Any

import grpc
from helloworld_pb2 import HelloRequest, HelloReply
from helloworld_pb2_grpc import MultiGreeterServicer, add_MultiGreeterServicer_to_server

from iris_adapterless_interop_agent import IRISAdapterlessInteropAgent, IRISConnectionInfo
from say_hello_request_message import SayHelloRequestMessage
from say_hello_stream_request_message import SayHelloStreamRequestMessage

NUMBER_OF_REPLY = 5

iris_connection_info = IRISConnectionInfo(**{
    "hostname": "localhost", 
    "port": 1972, 
    "namespace": "USER", 
    "username": "_SYSTEM", 
    "password": "SYS"
})
iris_agent = IRISAdapterlessInteropAgent(iris_connection_info)

class GreeterAdaterlessServer(MultiGreeterServicer):

    def SayHello(self, request: HelloRequest, context) -> HelloReply:
        global iris_agent
        logging.info("Serving SayHello request %s", request)
        # response = iris_agent.send_sync_request_to_business_service("GreeterAdapterlessServerBS", request.name)
        response = iris_agent.send_sync_request_to_business_service("GreeterAdapterlessServerBS", SayHelloRequestMessage(name=request.name))
        return HelloReply(message=response)

    def SayHelloStream(self, request: HelloRequest, context: grpc.aio.ServicerContext) -> HelloReply:
        logging.info("Serving SayHelloStream request %s", request)
        n = request.num_greetings
        if n == 0:
            n = NUMBER_OF_REPLY
        for i in range(n):
            # response = iris_agent.send_sync_request_to_business_service("GreeterAdapterlessServerBS", request.name)
            response = iris_agent.send_sync_request_to_business_service("GreeterAdapterlessServerBS", SayHelloStreamRequestMessage(name=request.name))
            yield HelloReply(message=response)

def get_server():
    # todo: verificar se ha possibilidade de parameterizar a porta
    port = 50051
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_MultiGreeterServicer_to_server(GreeterAdaterlessServer(), server)
    listen_addr = f"[::]:{port}"
    server.add_insecure_port(f"[::]:{port}")
    logging.info("Starting server on %s", listen_addr)
    return server

def handle_sigterm(*_: Any) -> None :
    """Shutdown gracefully."""
    done_event = server.stop(None)
    done_event.wait(None)
    print('Stop complete.')

logging.basicConfig(level=logging.INFO)

server = get_server()
server.start()

# listening for SIGTERM to gracefully stop the server
# https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3w
signal.signal(signal.SIGTERM, handle_sigterm)

server.wait_for_termination()