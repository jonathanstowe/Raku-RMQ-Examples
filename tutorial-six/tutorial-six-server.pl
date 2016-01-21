#!/usr/bin/env perl6 

use v6;

use Net::AMQP;


multi sub fib(Int() $i) returns Int {
	 (0 .. $i).reduce({ $^a + $^b });
}

multi sub fib(Blob $b) returns Int {
    fib($b.decode.Int);
}

my $n = Net::AMQP.new;

my $connection = $n.connect.result;

react {
    whenever $n.open-channel(1) -> $channel {
        $channel.qos(0,1);
        whenever $channel.declare-queue("rpc-queue") -> $queue {
            $queue.consume;
            whenever $queue.message-supply -> $message {
                say $message;
                my $to = $message.headers<reply-to>;
                my $ci = $message.headers<correlation-id>;
                my $body = fib($message.body).Str.encode;
                $channel.exchange.result.publish(routing-key => $to, correlation-id => $ci, body => $body);
            }
        }
    }
}

await $connection;




# vim: expandtab shiftwidth=4 ft=perl6
