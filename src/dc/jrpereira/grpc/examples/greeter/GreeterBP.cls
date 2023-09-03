/// 
Class dc.jrpereira.grpc.examples.greeter.GreeterBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='randNum' type='%Integer' initialexpression='0' instantiate='0' />
</context>
<sequence xend='200' yend='1050' >
<assign name="Random number [1,100]" property="context.randNum" value="$RANDOM(100)" action="set" xpos='200' ypos='250' />
<trace value='context.randNum_"; "_request.%ClassName(1)' xpos='200' ypos='350' />
<if name='number &lt;= 50' condition='context.randNum &lt;= 50' xpos='200' ypos='450' xend='200' yend='950' >
<true>
<if condition='request.%ClassName(1) = "dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage"' xpos='740' ypos='600' xend='740' yend='850' >
<annotation><![CDATA[request = "SayHelloRequestMessage"]]></annotation>
<true>
<call name='SayHelloGreeterBO' target='GreeterBO' async='0' xpos='1010' ypos='750' >
<request type='dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</true>
<false>
<call name='SayHelloStreamGreeterBO' target='GreeterBO' async='0' xpos='740' ypos='750' >
<request type='dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</false>
</if>
</true>
<false>
<if condition='request.%ClassName(1) = "dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage"' xpos='200' ypos='600' xend='200' yend='850' >
<annotation><![CDATA[request = "SayHelloRequestMessage"]]></annotation>
<true>
<call name='SayHelloGreeterCurrTimeBO' target='GreeterCurrentTimestampBO' async='0' xpos='470' ypos='750' >
<request type='dc.jrpereira.grpc.examples.greeter.msg.SayHelloRequestMessage' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</true>
<false>
<call name='SayHelloStreamGreeterCurrTimeBO' target='GreeterCurrentTimestampBO' async='0' xpos='200' ypos='750' >
<request type='dc.jrpereira.grpc.examples.greeter.msg.SayHelloStreamRequestMessage' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</false>
</if>
</false>
</if>
</sequence>
</process>
}

}
