Class dc.jrpereira.grpc.examples.greeter.experimental.GreeterInboundAdapter Extends EnsLib.PEX.InboundAdapter
{

/// This user callback method is called just after %OnNew()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterInboundAdapter][Proxy][OnInit]")
	Set ..%remoteClassname = "GreeterInboundAdapter"
	Set ..%gatewayName = "%Python Server"
	Set ..%gatewayExtraClasspaths = ##class(dc.jrpereira.grpc.examples.greeter.Utils).GetPythonServerClasspath()
	Return ##super()
}

/// This user callback method is called just before %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterInboundAdapter][Proxy][OnTearDown]")

	// Implements here any aditional logic before calling PEX OnTearDown() method in the Python class
    
	Set st = ##super()

	// Implements here any aditional logic after calling PEX OnTearDown() method in the Python class
    
    Return st
}

/// default InboundAdapter behavior: always call ProcessInput on CallInterval
Method OnTask() As %Status
{
    $$$TRACE("[GreeterInboundAdapter][Proxy][OnTask]")

	// Implements here any aditional logic before calling PEX OnTask() method in the Python class

	Set response = ##super()

	// Implements here any aditional logic after calling PEX OnTask() method in the Python class

    Return response
}

}
