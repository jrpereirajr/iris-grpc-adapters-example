from concurrent import futures
import logging
import signal
from typing import Any

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

# def handle_sigterm(*_: Any) -> None :
#     """Shutdown gracefully."""
#     done_event = server.stop(None)
#     done_event.wait(None)
#     print('Stop complete.')

logging.basicConfig(level=logging.INFO)

server = get_server()
server.start()

# # https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3w
# signal.signal(signal.SIGTERM, handle_sigterm)

# server.wait_for_termination()

# https://stackoverflow.com/a/58411106
import threading
done = threading.Event()
def on_done(signum, frame):
    logging.info('Got signal {}, {}'.format(signum, frame))
    done.set()
signal.signal(signal.SIGTERM, on_done)
done.wait()
logging.info('Stopped RPC server, Waiting for RPCs to complete...')
server.stop(10).wait()
logging.info('Done stopping server')