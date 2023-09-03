"""
The Python implementation of the GRPC helloworld.Greeter server.
Adapted from:
    - https://github.com/grpc/grpc/blob/master/examples/python/helloworld/async_greeter_server.py
    - https://github.com/grpc/grpc/blob/master/examples/python/hellostreamingworld/async_greeter_server.py
    - https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3w
"""

from concurrent import futures
import logging
import signal
from typing import Any
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

import grpc
from helloworld_pb2 import HelloRequest, HelloReply
from helloworld_pb2_grpc import MultiGreeterServicer, add_MultiGreeterServicer_to_server

# from server_interceptor import ServerInterceptor

import iris
import iris.pex

def CreateBusinessService(connection, target):
    """ The CreateBusinessService() method initiates the specifiied business service.

    Parameters:
    connection: an IRISConnection object that specifies the connection to an IRIS instance for Java.
    target: a string that specifies the name of the business service in the production definition.

    Returns:
        an object that contains an instance of IRISBusinessService
    """
    irisInstance = iris.IRIS(connection)
    irisobject = irisInstance.classMethodObject("EnsLib.PEX.Director","dispatchCreateBusinessService",target)
    # service = iris.pex._IRISBusinessService._IRISBusinessService()
    service = iris.pex._IRISBusinessService()
    service.irisHandle = irisobject
    return service

def create_iris_connection():
    connection = iris.createConnection(hostname="localhost", port=1972, namespace="USER",username="_SYSTEM",password="SYS")
    return connection

iris_connection = None

def sendRequest(host, msg):
    global iris_connection
    if iris_connection is None:
        iris_connection = create_iris_connection()
    # service = iris.pex.Director.CreateBusinessService(connection, "HelloWorldBusinessService")
    service = CreateBusinessService(iris_connection, host)
    response = service.ProcessInput(msg)
    return response

NUMBER_OF_REPLY = 3

parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
parser.add_argument("-p", "--port", default="50051", help="Server port")
args = vars(parser.parse_args())

class Greeter(MultiGreeterServicer):

    def SayHello(self, request: HelloRequest, context) -> HelloReply:
        logging.info("Serving SayHello request %s", request)
        # obj = iris.cls("dc.jrpereira.gRPC.HelloWorldServer")._New()
        # hook to your ObjectScript code
        # return obj.SayHelloObjectScript(request)

        # return HelloReply(message="Hello, %s!" % request.name)

        response = sendRequest("HelloWorldBusinessService", request.name)
        return HelloReply(message=response)

    def SayHelloStream(self, request: HelloRequest, context: grpc.aio.ServicerContext) -> HelloReply:
        logging.info("Serving SayHelloStream request %s", request)
        # obj = iris.cls("dc.jrpereira.gRPC.HelloWorldServer")._New()
        n = request.num_greetings
        if n == 0:
            n = NUMBER_OF_REPLY
        for i in range(n):
            # hook to your ObjectScript code
            # yield obj.SayHelloObjectScript(request)

            # yield HelloReply(message="Hello, %s!" % request.name)
            
            response = sendRequest("HelloWorldBusinessService", request.name)
            yield HelloReply(message=response)

def get_server():
    port = args["port"]
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=10),
        # interceptors=(ServerInterceptor(),),
    )
    add_MultiGreeterServicer_to_server(Greeter(), server)
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

# https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3w
signal.signal(signal.SIGTERM, handle_sigterm)

server.wait_for_termination()