Class dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage Extends dc.jrpereira.grpc.examples.greeter.msg.HelloRequestMessage
{

/// Description
ClassMethod CreateFromRemoteObject(pInput As %Net.Remote.Object) As dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage
{
	Set msg = ##class(dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage).%New()
	Set msg.name = pInput.name
	Set msg.numGreetings = pInput."num_greetings"

	Return msg
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
