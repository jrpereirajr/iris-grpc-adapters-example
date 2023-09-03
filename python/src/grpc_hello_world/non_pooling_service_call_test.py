import iris
import iris.pex

def CreateBusinessService(connection, target):
    """ The CreateBusinessService() method initiates the specifiied business service.

    Parameters:
    connection: an IRISConnection object that specifies the connection to an IRIS instance for Java.
    target: a string that specifies the name of the business service in the production definition.

    Returns:
        an object that contains an instance of IRISBusinessService
    """
    irisInstance = iris.IRIS(connection)
    irisobject = irisInstance.classMethodObject("EnsLib.PEX.Director","dispatchCreateBusinessService",target)
    # service = iris.pex._IRISBusinessService._IRISBusinessService()
    service = iris.pex._IRISBusinessService()
    service.irisHandle = irisobject
    return service

def sendRequest():
    connection = iris.createConnection(hostname="localhost", port=1972, namespace="USER",username="_SYSTEM",password="SYS")
    # service = iris.pex.Director.CreateBusinessService(connection, "HelloWorldBusinessService")
    service = CreateBusinessService(connection, "HelloWorldBusinessService")
    response = service.ProcessInput("request from non polling starter")
    return response

response = sendRequest()    
print(response)