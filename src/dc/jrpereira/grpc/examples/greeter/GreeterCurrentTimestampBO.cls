Class dc.jrpereira.grpc.examples.greeter.GreeterCurrentTimestampBO Extends Ens.BusinessOperation
{

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterCurrentTimestampBO][OnInit]")
	Return $$$OK
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterCurrentTimestampBO][OnTearDown]")
	Return $$$OK
}

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
    $$$TRACE("[GreeterCurrentTimestampBO][OnMessage]")
	Return $$$OK
}

Method ProcessSayHelloRequest(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage, Output pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage) As %Status
{
	$$$TRACE("[GreeterCurrentTimestampBO][ProcessSayHelloRequest]")
	Set st = $$$OK
	Set pResponse = ##class(dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage).%New()
	Set pResponse.message = "Hello from "_pRequest.origin_", "_pRequest.name_"!"
	Set pResponse.message = pResponse.message_" The current time is "_$ZDT($H,3)_"."
	Return st
}

Method ProcessSayHelloStreamRequest(pRequest As dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage, Output pResponse As dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage) As %Status
{
	$$$TRACE("[GreeterCurrentTimestampBO][ProcessSayHelloStreamRequest]")
	Set st = $$$OK
	Set pResponse = ##class(dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage).%New()
	Set pResponse.message = "Hello from "_pRequest.origin_", "_pRequest.name_"!"
	Set pResponse.message = pResponse.message_" The current time is "_$ZDT($H,3)_"."
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
