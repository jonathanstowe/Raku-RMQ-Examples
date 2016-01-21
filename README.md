# Perl 6 RabbitMQ Tutorial Examples

These are Perl 6 versions of the [Rabbit MQ Tutorial](http://www.rabbitmq.com/getstarted.html) examples.
They cover the basic patterns for creating messaging applications with Perl 6 and Rabbit MQ.

You will need to have [Rabbit MQ installed](http://www.rabbitmq.com/download.html) as well as Perl 6 and
the client library [Net::AMQP](https://github.com/retupmoca/P6-Net-AMQP).

You should have a version of Rakudo Perl 6 newer than approximately mid-January 2016 as there was a small but
crucial bug that got fixed around that time that prevented Net::AMQP from working.

You can install Net::AMQP directly with

```    panda install Net::AMQP````

You will need at least version v0.1.4 for these examples to work properly.


## ["Hello, World"](tutorial-001)

This is the simplest example that does something, a client that sends a simple
message to the broker and a single single subscriber that prints what it receives.

![Hello Image](http://www.rabbitmq.com/img/tutorials/python-one.png)

## [Work Queues](tutorial-002)

An example demonstrating how tasks can be distributed among a pool of workers.

![Work Image](http://www.rabbitmq.com/img/tutorials/python-two.png)

## [Publish/Subscribe](tutorial-003)

Demonstration of how a single message can be published to multiple consumers at once.

![Publish Image](http://www.rabbitmq.com/img/tutorials/python-three.png)

## [Routing](tutorial-004)

Selectively receiving message based on a publisher supplied key.

![Routing IMage](http://www.rabbitmq.com/img/tutorials/python-four.png)

## [Topics](tutorial-005)

Selectively receiving messages based on pattern matching.

![Topic Image](http://www.rabbitmq.com/img/tutorials/python-five.png)

## [RPC](tutorial-006)

Remote procedure calls implemented on a message queue.

![RPC Image](http://www.rabbitmq.com/img/tutorials/python-six.png)
