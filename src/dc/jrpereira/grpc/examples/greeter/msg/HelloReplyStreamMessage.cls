Class dc.jrpereira.grpc.examples.greeter.msg.HelloReplyStreamMessage Extends Ens.Response
{

Property messages As list Of dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage;

Storage Default
{
<Data name="HelloReplyStreamMessageDefaultData">
<Subscript>"HelloReplyStreamMessage"</Subscript>
<Value name="1">
<Value>messages</Value>
</Value>
</Data>
<DefaultData>HelloReplyStreamMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
