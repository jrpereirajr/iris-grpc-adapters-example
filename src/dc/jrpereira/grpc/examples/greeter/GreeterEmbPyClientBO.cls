/// todo: verificar possibilidades de criar mais duas classes de BO que implementam um cliente grpc externo (assim como foi feito nessa classe):
///  - uma usando um outbound adapter
///  - uma outra usando o director para se comunicar sem adapter
Class dc.jrpereira.grpc.examples.greeter.GreeterEmbPyClientBO Extends Ens.BusinessOperation
{

Property grpcStub As %SYS.Python;

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterEmbPyClientBO][OnInit]")
	Do ..ImportClasspath()
	Set ..grpcStub = ..GetGRPCStub()
	Return $$$OK
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterEmbPyClientBO][OnTearDown]")
	Return $$$OK
}

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
    $$$TRACE("[GreeterEmbPyClientBO][OnMessage]")
	Return $$$OK
}

Method Trace(msg As %String)
{
	$$$TRACE(msg)
}

Method ImportClasspath() [ Language = python ]
{
	import iris
	import sys
	path = iris.cls("dc.jrpereira.grpc.examples.greeter.Utils").GetPythonServerClasspath()
	sys.path.append(path)
}

Method GetGRPCStub() As %SYS.Python [ Language = python ]
{
	self.Trace("[GreeterEmbPyClientBO][GetGRPCStub]")

	import grpc
	from helloworld_pb2_grpc import MultiGreeterStub

	# todo: parameterizar a porta
	port = 50051
	channel = grpc.insecure_channel(f'localhost:{port}')
	stub = MultiGreeterStub(channel)

	return stub
}

Method CallSayHello(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage, pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage) As %Status
{
    $$$TRACE("[GreeterEmbPyClientBO][CallSayHello]")
	Set pResponse = ..SayHello(pRequest)
	Return $$$OK
}

Method SayHello(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage) As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage [ Language = python ]
{
	import iris
	from helloworld_pb2 import HelloRequest

	self.Trace("[GreeterEmbPyClientBO][SayHello]")
	grpc_response = self.grpcStub.SayHello(HelloRequest(name=pRequest.name))
	self.Trace("Greeter client received: " + grpc_response.message)

	response = iris.cls("dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage")._New()
	response.message = grpc_response.message
	return response
}

Method CallSayHelloStream(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage, pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyStreamMessage) As %Status
{
    $$$TRACE("[GreeterEmbPyClientBO][CallSayHelloStream]")
	Set pResponse = ..SayHelloStream(pRequest)
	Return $$$OK
}

Method SayHelloStream(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage) As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyStreamMessage [ Language = python ]
{
	import iris
	from helloworld_pb2 import HelloRequest

	self.Trace("[GreeterEmbPyClientBO][SayHelloStream]")
	response = iris.cls("dc.jrpereira.grpc.examples.greeter.msg.HelloReplyStreamMessage")._New()
	for grpc_response in self.grpcStub.SayHelloStream(HelloRequest(name=pRequest.name)):
		self.Trace("Greeter client received from stream: " + grpc_response.message)
		
		msg = iris.cls("dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage")._New()
		msg.message = grpc_response.message
		response.messages.Insert(msg)

	return response
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage">
    <Method>CallSayHello</Method>
  </MapItem>
  <MapItem MessageType="dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage">
    <Method>CallSayHelloStream</Method>
  </MapItem>
</MapItems>
}

}
