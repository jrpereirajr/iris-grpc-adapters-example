Class dc.jrpereira.grpc.examples.greeter.GreeterAdapterlessServerBS Extends Ens.BusinessService
{

Property TargetConfigName As Ens.DataType.ConfigName;

Parameter SETTINGS = "TargetConfigName:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterAdapterlessServerBS][OnInit]")
	Return $$$OK
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterAdapterlessServerBS][OnTearDown]")
	Return $$$OK
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	$$$TRACE("[GreeterAdapterlessServerBS][OnProcessInput]")
    $$$TRACE("pInput: "_pInput)
    
	Try {
		Set requestClassName = pInput."__repr__"()
		$$$TRACE("requestClassName: "_requestClassName)

		If (requestClassName [ "<say_hello_request_message.SayHelloRequestMessage") {
			Set msg = ##class(dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage).CreateFromRemoteObject(pInput)
			Set msg.origin = ..%ClassName()
			
		} ElseIf (requestClassName [ "<say_hello_stream_request_message.SayHelloStreamRequestMessage") {
			Set msg = ##class(dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage).CreateFromRemoteObject(pInput)
			Set msg.origin = ..%ClassName()
		}
		
		Set st = ..SendRequestSync(..TargetConfigName, msg, .response)

		$$$TRACE("Response: "_response)
		$$$TRACE("Response: "_response.message)
		Set pOutput = response.message
	} Catch (ex) {
		Set st = ex.AsStatus()
	}

    Quit $$$OK
}

}
