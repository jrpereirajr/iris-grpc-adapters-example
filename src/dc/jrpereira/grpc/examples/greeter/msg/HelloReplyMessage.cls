Class dc.jrpereira.grpc.examples.greeter.msg.HelloReplyMessage Extends Ens.Response
{

Property message As %String(MAXLEN = "");

Storage Default
{
<Data name="HelloReplyMessageDefaultData">
<Subscript>"HelloReplyMessage"</Subscript>
<Value name="1">
<Value>message</Value>
</Value>
</Data>
<DefaultData>HelloReplyMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
