import grpc
from grpc_interceptor import ServerInterceptor

import route_guide_pb2

class ServerInterceptor(ServerInterceptor):

    def intercept(self, method, request, context, method_name):
        self.printInfo(method, request, context, method_name)
        return method(request, context)
    
    def printInfo(self, method, request, context, method_name):
        print("[ServerInterceptor][intercept]")
        print(f"method: {method}")
        print(f"type(request): {type(request)}")
        # print(f"request.name: {request.name}")
        if type(request) is route_guide_pb2.Point:
            print(f"route_guide_pb2.Point: ({request.latitude},{request.longitude})")
        elif str(type(request)) == "<class 'grpc._server._RequestIterator'>":
            print("generator: aqui!")
            print(dir(request))
            for item in request:
                print(f"generator: item: {item}")
                print(f"generator: type(item): {type(item)}")
        print(f"context: {context}")
        print(f"method_name: {method_name}")
        print("---")
