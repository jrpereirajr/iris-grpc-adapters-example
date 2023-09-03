from iris.pex import InboundAdapter

from utils import log
from experimental.greeter_server_iris_inbound_adapter import GreeterInboundAdapterServer

class GreeterInboundAdapter(InboundAdapter):
    """
    The greeter server gRPC hello world example adapted as an IRIS Inbound Adapter
    """

    def __init__(self):
        """ The BusinessHost variable provides access to the business service associated with the inbound adapter.
        The adapter calls the IRISBusinessService.ProcessInput() method of the business service.
        """
        self.grpc_server = None
        super().__init__()

    def start_server(self):
        server = GreeterInboundAdapterServer()
        self.grpc_server = server.get_server(adapter=self)
        self.grpc_server.start()
        log(self, "server started")
    
    def stop_server(self):
        self.grpc_server.stop(None)
        log(self, "server stopped")

    def log_iris(self, msg):
        log(self, msg)

    def OnInit(self):
        """
        The OnInit() method is called when the component is started. Use the OnInit() method to initialize any structures needed by the component.
        """
        log(self, "OnInit() is called")
        self.start_server()

        return

    def OnTearDown(self):
        """
        The OnTearDown() method is called before the business component is terminated. Use the OnTeardown() method to free any structures.
        """
        log(self, "OnTeardown() is called")
        self.stop_server()

        return

    def OnTask(self):
        """ Called by the production framework at intervals determined by the business service CallInterval property.
        It is responsible for receiving the data from the external system, validating the data, and sending it in a message to the business service OnProcessInput method.
        The message can have any structure agreed upon by the inbound adapter and the business service.
        """
        log(self, "OnTask() is called")