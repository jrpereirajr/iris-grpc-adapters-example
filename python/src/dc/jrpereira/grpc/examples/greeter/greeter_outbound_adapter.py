from iris.pex import OutboundAdapter
from utils import log

import grpc
from helloworld_pb2 import HelloRequest
from helloworld_pb2_grpc import MultiGreeterStub

class GreeterOutboundAdapter(OutboundAdapter):
    """
    Custom Outbound Adapter in Python.
    """

    _stub = None
    
    def OnInit(self):
        log(self, "[OnInit]")
        self._stub = self.get_server()
        return

    def OnTearDown(self):
        log(self, "OnTeardown() is called")
        log(self, "[OnInit]")
        return

    def SendMessage(self, msg):
        log(self, "[SendMessage]")
        # log(self, f"msg: {msg.get('value')}")
        log(self, f"msg: {msg}")
        return msg
    
    def get_server(self):
        # todo: criar parametro no adapter
        port = 50051
        channel = grpc.insecure_channel(f'localhost:{port}')
        stub = MultiGreeterStub(channel)
        return stub
    
    def say_hello(self, name):
        response = self._stub.SayHello(HelloRequest(name=name))
        log(self, "Greeter client received: " + response.message)
        return response

    def run() -> None:
        port = args["port"]
        channel = grpc.insecure_channel(f'localhost:{port}')
        intercept_channel = grpc.intercept_channel(channel)
        stub = MultiGreeterStub(intercept_channel)

        response = stub.SayHello(HelloRequest(name=names.get_full_name()))
        print("Greeter client received: " + response.message)
        
        for response in stub.SayHelloStream(HelloRequest(name=names.get_full_name())):
            print("Greeter client received from stream: " + response.message)
