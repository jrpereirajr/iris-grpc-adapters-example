Class dc.jrpereira.grpc.examples.greeter.GreeterOutboundAdapterClientBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.jrpereira.grpc.examples.greeter.GreeterOutboundAdapter";

Property Adapter As dc.jrpereira.grpc.examples.greeter.GreeterOutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
    $$$TRACE("[GreeterOutboundAdapterClientBO][OnMessage]")
	Quit $$$OK
}

Method SayHello(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage, pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage) As %Status
{
    $$$TRACE("[GreeterOutboundAdapterClientBO][SayHello]")
	Set tSC = $$$OK
	Try {
		Set grpcResponse = ..Adapter.SayHello(pRequest)
		Set pResponse = ##class(dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage).%New()
		Set pResponse.message = grpcResponse."__getattribute__"("message")
	} Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SayHelloStream(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage, pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyStreamMessage) As %Status
{
    $$$TRACE("[GreeterOutboundAdapterClientBO][SayHelloStream]")
	Set tSC = $$$OK
	Try {
		Set pResponse = ..Adapter.SendMessage(pRequest)
	} Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage">
    <Method>SayHello</Method>
  </MapItem>
  <MapItem MessageType="dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage">
    <Method>SayHelloStream</Method>
  </MapItem>
</MapItems>
}

}
