Class dc.jrpereira.grpc.examples.greeter.GreeterOutboundAdapter Extends EnsLib.PEX.InboundAdapter
{

/// This user callback method is called just after %OnNew()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterOutboundAdapter][Proxy][OnInit]")
	Set ..%remoteClassname = "GreeterOutboundAdapter"
	Set ..%gatewayName = "%Python Server"
	Set ..%gatewayExtraClasspaths = ##class(dc.jrpereira.grpc.examples.greeter.Utils).GetPythonServerClasspath()
	Return ##super()
}

/// This user callback method is called just before %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterOutboundAdapter][Proxy][OnTearDown]")

	// Implements here any aditional logic before calling PEX OnTearDown() method in the Python class
    
	Set st = ##super()

	// Implements here any aditional logic after calling PEX OnTearDown() method in the Python class
    
    Return st
}

/// default InboundAdapter behavior: always call ProcessInput on CallInterval
Method OnTask() As %Status
{
    $$$TRACE("[GreeterOutboundAdapter][Proxy][OnTask]")

	// Implements here any aditional logic before calling PEX OnTask() method in the Python class

	Set response = ##super()

	// Implements here any aditional logic after calling PEX OnTask() method in the Python class

    Return response
}

Method SendMessage(message As %Library.Persistent) As %Library.Persistent
{
    $$$TRACE("[GreeterOutboundAdapter][Proxy][SendMessage]")
    Set response = ..%gatewayProxy.SendMessage(message)
	Return response
}

Method SayHello(message As %Library.Persistent) As %Library.Persistent
{
    $$$TRACE("[GreeterOutboundAdapter][Proxy][SayHello]")
    Set response = ..%gatewayProxy."say_hello"(message.name)
    #; Set response = ..%gatewayProxy.SendMessage(message)
	Return response
}

}
