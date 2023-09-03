# https://stackoverflow.com/a/6921402
from multiprocessing.connection import Client

# address = ('localhost', 6000)
port = int(open("multiproc_test_port.txt", "r").read())
address = ('localhost', port)
conn = Client(address, authkey=b'secret password')
conn.send({'status': 'open', 'name': 'jose'})
conn.send({'status': 'close', 'name': 'jose1'})
# can also send arbitrary objects:
# conn.send(['a', 2.5, None, int, sum])
conn.close()