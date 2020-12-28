# sb-miniproject9
Building A Streaming Fraud Detection System With Kafka + Python


## How to run
* Step 1: Build and start the kafka container
```
docker-compose -f docker-compose.kafka.yml build && docker-compose -f docker-compose.kafka.yml up
```

* Step 2: Build and start the producer (generator) and consumer (detector)
```
docker-compose build && docker-compose up
```

* Test the consumer using built-in `kafka-console-consumer`
```
docker-compose -f docker-compose.kafka.yml exec broker kafka-console-consumer --bootstrap-server localhost:9092 --topic streaming.transactions.fraud
docker-compose -f docker-compose.kafka.yml exec broker kafka-console-consumer --bootstrap-server localhost:9092 --topic streaming.transactions.legit
```
## Application Design and Implementation
As illustrated in the below figure, we use two docker container groups that work independently and share the same network. One is for the background Kafka service (zookeeper + kafka borker) and another is for our application (producer + consumer).
![Application Design](images/diagram.jpg)
### Kafka container
In this container group, we use zookeeper and kafka images (broker) from Confluentinc. The broker listens on port 9092 (`KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://broker:9092`) and connect to the zookeeper through port 32181 (`KAFKA_ZOOKEEPER_CONNECT=zookeeper:32181`).

docker-compose.kafka.yml
```
 version: "3" 
 
 services:
     zookeeper:
         image: confluentinc/cp-zookeeper:latest
         hostname: zookeeper
         ports:
             - '32181:32181'                                                                                                                                                                                      
         environment:
             ZOOKEEPER_CLIENT_PORT: 32181
             ZOOKEEPER_TICK_TIME: 2000
     broker:
         image: confluentinc/cp-kafka:latest
         depends_on:
             - zookeeper
         environment:
             - KAFKA_BROKER_ID=1
             - KAFKA_ZOOKEEPER_CONNECT=zookeeper:32181
             - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://broker:9092
             - KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
 networks:
     default:
         external:
             name: kafka-network

```
## Application container
We implement our application followed the single-event processing design pattern such that the pruducer writes transaction events into one topic and the consumer reads events in that topic and uses a helper function to classify the event type (legit/fraud). 
* ***How to classify events?***: We assume that a transaction event is fraud if its amount exceed $900.
