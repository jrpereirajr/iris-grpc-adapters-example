Class dc.jrpereira.grpc.examples.greeter.msg.HelloRequestMessage Extends Ens.Request
{

Property name As %String;

Property numGreetings As %Integer;

Property origin As %String;

Storage Default
{
<Data name="HelloRequestMessageDefaultData">
<Subscript>"HelloRequestMessage"</Subscript>
<Value name="1">
<Value>name</Value>
</Value>
<Value name="2">
<Value>numGreetings</Value>
</Value>
<Value name="3">
<Value>origin</Value>
</Value>
</Data>
<DefaultData>HelloRequestMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
