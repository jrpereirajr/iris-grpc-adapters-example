import grpc
from grpc_interceptor import ServerInterceptor

# class ServerInterceptor(grpc.ServerInterceptor):
class ServerInterceptor(ServerInterceptor):

    # The interceptors for official gRPC API does not support retrieving the request;
    # so the grpc_interceptor library was used for implementation of server interceptor
    # def intercept_service(self, continuation, handler_call_details):
    #     print("[ServerInterceptor][intercept_service]")
    #     print(handler_call_details)
    #     print(handler_call_details.method)
    #     print(handler_call_details.invocation_metadata)
    #     return continuation(handler_call_details)
    
    def intercept(self, method, request, context, method_name):
        self.printInfo(method, request, context, method_name)
        return method(request, context)
    
    def printInfo(self, method, request, context, method_name):
        print("[ServerInterceptor][intercept]")
        print(f"method: {method}")
        print(f"type(request): {type(request)}")
        print(f"request.name: {request.name}")
        print(f"context: {context}")
        print(f"method_name: {method_name}")
