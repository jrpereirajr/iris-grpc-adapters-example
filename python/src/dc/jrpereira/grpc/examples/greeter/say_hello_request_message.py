from iris.pex import Message

class SayHelloRequestMessage(Message):

    def __init__(self, name=None, num_greetings=None):
        self.name = name
        self.num_greetings = num_greetings
        super().__init__()