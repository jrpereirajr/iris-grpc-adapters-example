import iris
import iris.pex
from typing import NamedTuple

class IRISConnectionInfo(NamedTuple):
    hostname: str
    port: str
    namespace: str
    username: str
    password: str

class IRISAdapterlessInteropAgent():

    def __init__(self, connection_info: IRISConnectionInfo=None, connection=None):
        self.connection_info = connection_info
        
        if connection is None:
            connection = self.create_iris_connection()
        self.connection = connection

    # todo: this is a modified version - to avoid error, from orignial pex file:
    # /usr/irissys/dev/python/virtual/%Python\ Server_3252368016/lib/python3.10/site-packages/iris/pex/_Director.py
    # report the problem with the following line
    #       service = iris.pex._IRISBusinessService._IRISBusinessService()
    # this line generates a erro due the iris.pex._IRISBusinessService property returns None
    def __CreateBusinessService(self, target):
        """ The CreateBusinessService() method initiates the specifiied business service.

        Parameters:
        connection: an IRISConnection object that specifies the connection to an IRIS instance for Java.
        target: a string that specifies the name of the business service in the production definition.

        Returns:
            an object that contains an instance of IRISBusinessService
        """
        irisInstance = iris.IRIS(self.connection)
        irisobject = irisInstance.classMethodObject("EnsLib.PEX.Director","dispatchCreateBusinessService",target)
        # service = iris.pex._IRISBusinessService._IRISBusinessService()
        service = iris.pex._IRISBusinessService()
        service.irisHandle = irisobject
        return service

    def create_business_service(self, target):
        # todo: after sending the CreateBusinessService() method error, use the following code
        # return iris.pex.Director.CreateBusinessService(connection, host)
        return self.__CreateBusinessService(target)

    def create_iris_connection(self):
        connection = iris.createConnection(**self.connection_info._asdict())
        return connection
    
    def send_sync_request_to_business_service(self, host, msg):
        # todo: manipular esse erro (ocorre quando o python gateway é reiniciado e o servidor grpc ainda está usando a conexão antiga):
        # ERROR:grpc._server:Exception calling application: cannot create an IRIS object with a closed connection
        # Traceback (most recent call last):
        # File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/grpc/_server.py", line 552, in _call_behavior
        #     response_or_iterator = behavior(argument, context)
        # File "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/greeter_server_iris_adapterless.py", line 39, in SayHello
        #     response = iris_agent.send_sync_request_to_business_service("GreeterAdapterlessServerBS", SayHelloRequestMessage(name=request.name))
        # File "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/iris_adapterless_interop_agent.py", line 53, in send_sync_request_to_business_service
        #     service = self.create_business_service(host)
        # File "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/iris_adapterless_interop_agent.py", line 46, in create_business_service
        #     return self.__CreateBusinessService(target)
        # File "/home/irisowner/irisdev/python/src/dc/jrpereira/grpc/examples/greeter/iris_adapterless_interop_agent.py", line 36, in __CreateBusinessService
        #     irisInstance = iris.IRIS(self.connection)
        # File "/usr/irissys/dev/python/virtual/%Python Server_3252368016/lib/python3.10/site-packages/iris/_IRIS.py", line 60, in __init__
        #     raise ValueError("cannot create an IRIS object with a closed connection")
        # ValueError: cannot create an IRIS object with a closed connection
        service = self.create_business_service(host)
        response = service.ProcessInput(msg)
        return response