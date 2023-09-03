"""
The Python implementation of the GRPC helloworld.Greeter server.
Adapted from:
    - https://github.com/grpc/grpc/blob/master/examples/python/helloworld/async_greeter_server.py
    - https://github.com/grpc/grpc/blob/master/examples/python/hellostreamingworld/async_greeter_server.py
    - https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3w
"""

import logging
from concurrent import futures

import grpc
from helloworld_pb2 import HelloRequest, HelloReply
from helloworld_pb2_grpc import MultiGreeterServicer, add_MultiGreeterServicer_to_server

from say_hello_request_message import SayHelloRequestMessage
from say_hello_stream_request_message import SayHelloStreamRequestMessage

NUMBER_OF_REPLY = 5

class GreeterInboundAdapterServer(MultiGreeterServicer):

    def __init__(self) -> None:
        logging.basicConfig(
            filename='/tmp/greeter_server_iris_inbound_adapter.log', 
            encoding='utf-8', 
            level=logging.DEBUG
        )

        logging.info("__init__")
        self.adapter = None
        super().__init__()

    def SayHello(self, request: HelloRequest, context) -> HelloReply:
        import traceback
        try:
            response = self.adapter.BusinessHost.ProcessInput(SayHelloRequestMessage(name=request.name))
            logging.info("response %s", response)
        except Exception as e:
            logging.error(traceback.format_exc())
            logging.error(e)
        return HelloReply(message="response.name")
        # return HelloReply(message="Hello, %s!" % request.name)

    def SayHelloStream(self, request: HelloRequest, context: grpc.aio.ServicerContext) -> HelloReply:
        logging.info("Serving SayHelloStream request %s", request)
        n = request.num_greetings
        if n == 0:
            n = NUMBER_OF_REPLY
        for i in range(n):
            response = self.adapter.BusinessHost.ProcessInput(SayHelloStreamRequestMessage(name=request.name))
            yield HelloReply(message="response.name")
            # yield HelloReply(message="Hello, %s!" % request.name)

    def get_server(self, adapter):
        self.adapter = adapter

        # todo: criar parametro no adapter
        port = 50052
        server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
        add_MultiGreeterServicer_to_server(self, server)
        listen_addr = f"[::]:{port}"
        server.add_insecure_port(f"[::]:{port}")
        logging.info("-->Starting server on %s", listen_addr)

        response = self.adapter.BusinessHost.ProcessInput(SayHelloRequestMessage(name='request.name'))
        logging.info("response %s", response)
        
        return server