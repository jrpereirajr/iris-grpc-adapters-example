import grpc

class ClientInterceptor(grpc.UnaryUnaryClientInterceptor, grpc.UnaryStreamClientInterceptor, grpc.StreamUnaryClientInterceptor, grpc.StreamStreamClientInterceptor):
    
    def intercept_unary_unary(self, continuation, client_call_details, request):
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response
    
    def intercept_unary_stream(self, continuation, client_call_details, request):
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response
    
    def intercept_stream_unary(self, continuation, client_call_details, request):
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response
    
    def intercept_stream_stream(self, continuation, client_call_details, request):
        self.printInfo(client_call_details, request)
        response = continuation(client_call_details, request)
        return response

    def printInfo(self, client_call_details, request):
        print("[ClientInterceptor][intercept_unary_unary]")
        print(client_call_details)
        print(type(request))
        print(request.name)