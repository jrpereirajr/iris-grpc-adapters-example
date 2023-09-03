Class dc.jrpereira.grpc.examples.greeter.GreeterBO Extends Ens.BusinessOperation
{

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterBO][OnInit]")
	Return $$$OK
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterBO][OnTearDown]")
	Return $$$OK
}

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
    $$$TRACE("[GreeterBO][OnMessage]")
	Return $$$OK
}

Method ProcessSayHelloRequest(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage, Output pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage) As %Status
{
	$$$TRACE("[GreeterBO][ProcessSayHelloRequest]")
	Set st = $$$OK
	Set pResponse = ##class(dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage).%New()
	Set pResponse.message = "Hello from "_pRequest.origin_", "_pRequest.name_"!"
	Return st
}

Method ProcessSayHelloStreamRequest(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage, Output pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage) As %Status
{
	$$$TRACE("[GreeterBO][ProcessSayHelloStreamRequest]")
	Set st = $$$OK
	Set pResponse = ##class(dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage).%New()
	Set pResponse.message = "Hello from "_pRequest.origin_", "_pRequest.name_"!"
	Return st
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage">
    <Method>ProcessSayHelloRequest</Method>
  </MapItem>
  <MapItem MessageType="dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage">
    <Method>ProcessSayHelloStreamRequest</Method>
  </MapItem>
</MapItems>
}

}
