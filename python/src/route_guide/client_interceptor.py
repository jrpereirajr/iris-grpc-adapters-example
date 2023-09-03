import grpc
# from grpc_interceptor import ClientCallDetails, ClientInterceptor

import route_guide_pb2

class ClientInterceptor(grpc.UnaryUnaryClientInterceptor, grpc.UnaryStreamClientInterceptor, grpc.StreamUnaryClientInterceptor, grpc.StreamStreamClientInterceptor):
# class ClientInterceptor(ClientInterceptor):
    
    # def intercept(self, method, request_or_iterator, call_details):
    #     print(method)
    #     print(request_or_iterator)
    #     print(call_details)
    #     new_details = ClientCallDetails(
    #         call_details.method,
    #         call_details.timeout,
    #         [],
    #         call_details.credentials,
    #         call_details.wait_for_ready,
    #         call_details.compression,
    #     )

    #     return method(request_or_iterator, new_details)

    def intercept_unary_unary(self, continuation, client_call_details, request):
        print("[ClientInterceptor][intercept_unary_unary]")
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response
    
    def intercept_unary_stream(self, continuation, client_call_details, request):
        print("[ClientInterceptor][intercept_unary_stream]")
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response
    
    def intercept_stream_unary(self, continuation, client_call_details, request):
        print("[ClientInterceptor][intercept_stream_unary]")
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response
    
    def intercept_stream_stream(self, continuation, client_call_details, request):
        print("[ClientInterceptor][intercept_stream_stream]")
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response

    def printInfo(self, client_call_details, request):
        print(f"client_call_details : {client_call_details}")
        print(f"type(request) : {type(request)}")
        # print(f"requet is route_guide_pb2.Point: {type(request) is route_guide_pb2.Point}")
        if type(request) is route_guide_pb2.Point:
            print(f"route_guide_pb2.Point: ({request.latitude},{request.longitude})")
        elif str(type(request)) == "<class 'generator'>":
            print("generator: aqui!")
            for item in request:
                print(f"generator: item: {item}")
                print(f"generator: type(item): {type(item)}")
        print("---")