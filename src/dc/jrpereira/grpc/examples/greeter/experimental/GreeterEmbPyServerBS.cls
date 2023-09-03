/*
ERROR:root:Traceback (most recent call last):
  File "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/greeter_server_iris_inbound_adapter.py", line 48, in SayHello
    response = self.adapter.teste(request, logging)
  File "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/greeter_inbound_adapter.py", line 62, in teste
    response = self.BusinessHost.ProcessInput('SayHelloRequestMessage(name="request.name")')
  File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/pex/_IRISBusinessService.py", line 16, in ProcessInput
    return (self.irisHandle._iris).classMethodObject("EnsLib.PEX.BusinessService", "dispatchProcessInput", self.irisHandle, input)
  File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/_IRIS.py", line 780, in classMethodObject
    return self._execute(object, iris.IRIS.VALUE_CLASSMETHOD, className, methodName, args)
  File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/_IRIS.py", line 970, in _execute
    code = self._in_message._read_message_sysio(sequence_number, allowedErrors)
  File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/_InStream.py", line 34, in _read_message_sysio
    is_for_gateway = self.__read_message_internal(expected_message_id, -1, iris._InStream._InStream.IRISNATIVE)
  File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/_InStream.py", line 59, in __read_message_internal
    self.__read_buffer(header.buffer, 0, iris._MessageHeader._MessageHeader.HEADER_SIZE)
  File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/_InStream.py", line 141, in __read_buffer
    raise Exception("Server unexpectedly closing communication device")
Exception: Server unexpectedly closing communication device
*/

Class dc.jrpereira.grpc.examples.greeter.experimental.GreeterEmbPyServerBS Extends Ens.BusinessService
{

/// Used to be named %ProcessInputCalled, with inverse sense
Property %WaitForNextCallInterval As %Boolean [ InitialExpression = 1 ];

Property TargetConfigName As Ens.DataType.ConfigName;

Property Adapter As dc.jrpereira.grpc.examples.greeter.experimental.GreeterEmbPyInboundAdapter;

Parameter ADAPTER = "dc.jrpereira.grpc.examples.greeter.GreeterEmbPyInboundAdapter";

Parameter SETTINGS = "TargetConfigName:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
    $$$TRACE("[GreeterEmbPyServerBS][OnInit]")
	Do ..StartServer()
    $$$TRACE("servidor iniciado")
	Return $$$OK
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
    $$$TRACE("[GreeterEmbPyServerBS][OnTearDown]")
	Do ..StopServer()
    $$$TRACE("servidor finalizado")
	Return $$$OK
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	$$$TRACE("[GreeterEmbPyServerBS][OnProcessInput]")
    $$$TRACE("pInput: "_pInput)

    If ($ISOBJECT(pInput)) {
        Set msg = ##class(Ens.StringRequest).%New()
        Set msg.StringValue = pInput
        Set st = ..SendRequestSync(..TargetConfigName, msg, .response)
        $$$TRACE("Response: "_response)
        $$$TRACE("Response: "_response.StringValue)
        Set pOutput = response.StringValue
    }
    
	Set ..%WaitForNextCallInterval = 1

    Quit $$$OK
}

Property ServerPID As %Integer;

Method StartServer()
{
    Job ..CreateServer()
    Set ..ServerPID = $ZCHILD
}

Method StopServer() [ Language = python ]
{
    import os
    import signal
    os.kill(self.ServerPID, signal.SIGTERM)
}

ClassMethod CreateServer() [ Language = python ]
{
    import logging
    logging.basicConfig(
        filename='/tmp/greeter_emb_py_server_bs.log', 
        encoding='utf-8', 
        level=logging.DEBUG
    )

    try:
        import iris
            
        import sys
        logging.info('0')
        path = iris.cls("dc.jrpereira.grpc.examples.greeter.Utils").GetPythonServerClasspath()
        logging.info(path)
        sys.path.append(path)

        from concurrent import futures
        import signal
        from typing import Any

        import grpc
        from helloworld_pb2 import HelloRequest, HelloReply
        from helloworld_pb2_grpc import MultiGreeterServicer, add_MultiGreeterServicer_to_server

        NUMBER_OF_REPLY = 10
        
        class Greeter(MultiGreeterServicer):

            def SayHello(self, request: HelloRequest, context) -> HelloReply:
                logging.info("Serving SayHello request %s", request)
                return HelloReply(message="Hello, %s!" % request.name)

            def SayHelloStream(self, request: HelloRequest, context: grpc.aio.ServicerContext) -> HelloReply:
                logging.info("Serving SayHelloStream request %s", request)
                n = request.num_greetings
                if n == 0:
                    n = NUMBER_OF_REPLY
                for i in range(n):
                    yield HelloReply(message="Hello, %s!" % request.name)

        def get_server():
            port = 50053
            server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
            add_MultiGreeterServicer_to_server(Greeter(), server)
            listen_addr = f"[::]:{port}"
            server.add_insecure_port(f"[::]:{port}")
            logging.info("Starting server on %s", listen_addr)
            return server

        def handle_sigterm(*_: Any) -> None :
            """Shutdown gracefully."""
            done_event = server.stop(None)
            done_event.wait(None)
            logging.info('Stop complete.')

        #; logging.basicConfig(level=logging.INFO)

        server = get_server()
        server.start()

        # https://groups.google.com/g/grpc-io/c/6Yi_oIQsh3w
        signal.signal(signal.SIGTERM, handle_sigterm)

        server.wait_for_termination()
    except Exception as e:
        logging.info(traceback.format_exc())
        logging.info(e)
}

}
