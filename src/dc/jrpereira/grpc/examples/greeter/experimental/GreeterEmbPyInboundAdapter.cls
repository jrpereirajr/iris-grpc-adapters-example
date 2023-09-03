Class dc.jrpereira.grpc.examples.greeter.experimental.GreeterEmbPyInboundAdapter Extends Ens.InboundAdapter
{

Property grpcServer As %SYSTEM.Python;

/// This user callback method is called just after %OnNew()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterEmbPyInboundAdapter][OnInit]")
	Quit $$$OK
}

/// This user callback method is called just before %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterEmbPyInboundAdapter][OnTearDown]")
	Quit $$$OK
}

/// default InboundAdapter behavior: always call ProcessInput on CallInterval
Method OnTask() As %Status
{
    $$$TRACE("[GreeterEmbPyInboundAdapter][OnTearDown]")

    Set tSC = 1

    #; Set msg = {"name": "Pereira"}
    #; Set tSC = ..BusinessHost.ProcessInput(msg)
	#; #; Set ..BusinessHost.%WaitForNextCallInterval=1

    Quit tSC
}

}
