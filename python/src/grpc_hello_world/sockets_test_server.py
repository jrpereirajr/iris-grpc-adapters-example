# https://realpython.com/python-sockets/
# echo-server.py

import socket

HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
# PORT = 65432  # Port to listen on (non-privileged ports are > 1023)

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, 0))
    PORT = s.getsockname()[1]
    print(f"port: {PORT}")
    # https://stackoverflow.com/questions/1365265/on-localhost-how-do-i-pick-a-free-port-number
    with open("sockets_test_port.txt", "w") as f:
        f.write(str(PORT))
        
    s.listen()
    conn, addr = s.accept()
    with conn:
        print(f"Connected by {addr}")
        while True:
            data = conn.recv(1024)
            if not data:
                break
            else:
                print(f"Received {data!r}")
            conn.sendall(data)