#!/usr/bin/env perl6 

use v6;

use Net::AMQP;

my $n = Net::AMQP.new;
await $n.connect;
my $channel = $n.open-channel(1).result;;
$channel.exchange.result.publish(routing-key => "hello", body => "Hello, World".encode);
await $n.close("", "");
