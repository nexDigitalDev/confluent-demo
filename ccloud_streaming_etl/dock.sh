docker run --rm edenhill/kafkacat:1.5.0 \
      -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN \
      -X ssl.ca.location=./etc/ssl/cert.pem -X api.version.request=true \
      -b pkc-ymrq7.us-east-2.aws.confluent.cloud:9092 \
      -X sasl.username="SEZFKI6NULHDRSGL"\
      -X sasl.password="tb6Zm2xLa2VKZstGvwm1U2t6xuV/YNTLp3WDS1D6/uSJNEp4Hu/SwXSIjv0jUJRg" \
      -r https://KMOC2SYUVPQ75ZIN:VESY8kKJ9AAbYv7K%2Blp%2FDxYFYQLg5gBXVKB8JyR1F9UPJkMVf5t7g9KhspT9%2B3fW@psrc-zj6ny.us-east-2.aws.confluent.cloud \
      -s avro \
      -t mysql-01-asgard.demo.CUSTOMERS \
      -C -o beginning
