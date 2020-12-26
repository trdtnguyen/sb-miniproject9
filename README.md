# sb-miniproject9
Building A Streaming Fraud Detection System With Kafka + Python


## How to run
* Step 1: Build and start the kafka container
```
docker-compose -f docker-compose.kafka.yml build && docker-compose -f docker-compose.kafka.yml up
```

* Step 2: Build and start the producer (generator)
```
docker-compose build && docker-compose up
```

* Test the consumer using built-in `kafka-console-consumer`
```
docker-compose -f docker-compose.kafka.yml exec broker kafka-console-consumer --bootstrap-server localhost:9092 --topic queueing.transactions --from-beginning
```
