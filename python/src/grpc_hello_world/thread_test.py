# SuperFastPython.com
# example of a triggered daemon thread
from time import sleep
from random import random
from threading import Thread
from queue import SimpleQueue
 
# task that runs when triggered
def background_task(msg_queue):
    # run forever
    while True:
        # get the next message
        message = msg_queue.get()
        # log the message
        print(f'LOG: {message}')
 
# create the message queue
msg_queue = SimpleQueue()
# create and start the daemon thread
print('Starting background task...')
daemon = Thread(target=background_task, args=(msg_queue,), daemon=True, name='Background')
daemon.start()
# main thread is carrying on...
print('Main thread is carrying on...')
for _ in range(5):
    # block for a while
    value = random() * 5
    sleep(value)
    # log an application result
    msg_queue.put(f'computed {value}')
print('Main thread done.')