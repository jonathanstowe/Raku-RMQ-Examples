#!/usr/bin/env perl6

use v6.c;

use Net::AMQP;

my $n = Net::AMQP.new(:debug);
my $connection = $n.connect.result;
react {
    whenever $n.open-channel(1) -> $channel {
        $channel.qos(0,1);
        whenever $channel.declare-queue("task_queue", :durable) -> $q {
            $q.consume(:ack);
            whenever $q.message-supply -> $message {
                say $message.body.decode;
                sleep (^10).pick;
                $channel.ack($message.delivery-tag);
            }
        }
    }
}
# vim: expandtab shiftwidth=4 ft=perl6
