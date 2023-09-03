Class dc.jrpereira.grpc.examples.greeter.experimental.GreeterProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.jrpereira.grpc.examples.greeter.experimental.GreeterProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="GreeterAdapterlessServerBS" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.GreeterAdapterlessServerBS" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">GreeterBP</Setting>
  </Item>
  <Item Name="GreeterInboundAdapterServerBS" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.experimental.GreeterInboundAdapterServerBS" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">GreeterBP</Setting>
  </Item>
  <Item Name="GreeterBO" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.GreeterBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="GreeterCurrentTimestampBO" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.GreeterCurrentTimestampBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="GreeterBP" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.GreeterBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="GreeterEmbPyClientBO" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.GreeterEmbPyClientBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="GreeterEmbPyServerBS" Category="" ClassName="dc.jrpereira.grpc.examples.greeter.experimental.GreeterEmbPyServerBS" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
