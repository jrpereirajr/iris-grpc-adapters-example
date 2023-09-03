from concurrent import futures
import threading
import logging

import grpc
from helloworld_pb2 import HelloRequest, HelloReply
from helloworld_pb2_grpc import MultiGreeterServicer, add_MultiGreeterServicer_to_server

import iris

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

def get_server():
    port = 50051
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_MultiGreeterServicer_to_server(Greeter(), server)
    listen_addr = f"[::]:{port}"
    server.add_insecure_port(f"[::]:{port}")
    logging.info("Starting server on %s", listen_addr)
    return server

server = None
x = None

def thread_function():
    global server
    server = get_server()
    server.start()
    print("server started, waiting for requests...")
    server.wait_for_termination()
    print("server no longer waiting for requests")

def start_server():
    x = threading.Thread(target=thread_function, args=(), daemon=True)
    x.start()
    print("server started")

def stop_server():
    print(server)
    server.stop(True)
    print("server stopped")

while True:
    user_input = input("Enter start, stop or quit: ")
    if user_input == "quit":
        break
    elif user_input == "start":
        start_server()
    elif user_input == "stop":
        stop_server()