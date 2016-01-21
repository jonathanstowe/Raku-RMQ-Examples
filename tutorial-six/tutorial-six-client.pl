#!/usr/bin/env perl6 

use v6.c;

use Net::AMQP;

class FibonacciClient {
    has Net::AMQP          $!client;
    has Net::AMQP::Channel $!channel;
    has Net::AMQP::Queue   $!queue;

    submethod BUILD() {
        $!client = Net::AMQP.new;
        await $!client.connect;
        $!channel = $!client.open-channel(1).result;
        $!queue = $!channel.declare-queue('', :exclusive).result;
        $!queue.consume;
    }

    method call(Int $i) returns Int {
        my $ci = correlation-id();

        my $p = Promise.new;

        my $t = $!queue.message-supply.grep({ $_.headers<correlation-id> eq $ci }).tap( -> $m {
            $t.close;
            $p.keep: $m.body.decode.Int;
        });

        my $body =  $i.Str.encode;

        $!channel.exchange.result.publish(body => $body, routing-key => 'rpc-queue', reply-to => $!queue.name, correlation-id => $ci);
        await $p;
    }

    sub correlation-id() returns Str {
        use nqp;  
        nqp::sha1(rand ~ $*PID ~ DateTime.now.Str);
    }
   
}

multi sub MAIN(Int $i) {
    say FibonacciClient.new.call($i);
}



# vim: expandtab shiftwidth=4 ft=perl6
