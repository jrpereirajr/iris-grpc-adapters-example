from threading import Thread, Event

from concurrent import futures
import logging
from typing import Any

import grpc
from helloworld_pb2 import HelloRequest, HelloReply
from helloworld_pb2_grpc import MultiGreeterServicer, add_MultiGreeterServicer_to_server

NUMBER_OF_REPLY = 10

class Greeter(MultiGreeterServicer):

    def SayHello(self, request: HelloRequest, context) -> HelloReply:
        logging.info("Serving SayHello request %s", request)
        return HelloReply(message="Hello, %s!" % request.name)

    def SayHelloStream(self, request: HelloRequest, context: grpc.aio.ServicerContext) -> HelloReply:
        logging.info("Serving SayHelloStream request %s", request)
        n = request.num_greetings
        if n == 0:
            n = NUMBER_OF_REPLY
        for i in range(n):
            yield HelloReply(message="Hello, %s!" % request.name)

logging.basicConfig(level=logging.INFO)

class Server:
    def __init__(self):
        self.event = None
        self.thread = None
        self.status = 'stopped'
        self.server = None
    
    def listen(self):
        self.server = self.get_server()
        self.server.start()
        print("server listening...")
        self.event.wait()
        print("server released...")

    def get_server(self):
        port = 50051
        server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
        add_MultiGreeterServicer_to_server(Greeter(), server)
        listen_addr = f"[::]:{port}"
        server.add_insecure_port(f"[::]:{port}")
        logging.info("Starting server on %s", listen_addr)
        return server

    def start(self):
        if self.thread is None or not self.thread.is_alive():
            self.event = Event()
            self.thread = Thread(target=self.listen)
            self.thread.start()
            self.status = 'started'
            print("server started")

    def stop(self):
        if self.thread is not None and self.thread.is_alive():
            self.server.stop(True)
            self.event.set()
            self.status = 'stopped'
            print("server stopped")

server = Server()
while True:
    user_input = input("Enter start, stop or quit: ")
    if user_input == "quit":
        break
    elif user_input == "start":
        server.start()
    elif user_input == "stop":
        server.stop()