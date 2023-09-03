# https://stackoverflow.com/a/6921402
from multiprocessing.connection import Listener

import socket
from contextlib import closing

def find_free_port():
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]

# https://stackoverflow.com/questions/1365265/on-localhost-how-do-i-pick-a-free-port-number
port = find_free_port()
print(f"port: {port}")
with open("multiproc_test_port.txt", "w") as f:
    f.write(str(port))

# address = ('localhost', 6000)     # family is deduced to be 'AF_INET'
address = ('localhost', port)     # family is deduced to be 'AF_INET'
listener = Listener(address, authkey=b'secret password')
conn = listener.accept()
print('connection accepted from', listener.last_accepted)
while True:
    msg = conn.recv()
    print('received', msg)
    # do something with msg
    if msg['status'] == 'close':
        print(msg['name'])
        conn.close()
        break
listener.close()