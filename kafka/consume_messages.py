import pulsar

client = pulsar.Client('pulsar://pulsar:6650')
consumer = client.subscribe('employees',
                            subscription_name='my-sub')

while True:
    msg = consumer.receive()
    print("Received message: '%s'" % msg.data())
    consumer.acknowledge(msg)

client.close()
