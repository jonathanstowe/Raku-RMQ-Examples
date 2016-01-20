#!/usr/bin/env perl6

use Net::AMQP;

multi sub MAIN(Str $body = 'Hello, World') {
    my $n = Net::AMQP.new;
    my $con =  await $n.connect;
    my $channel = $n.open-channel(1).result;
    my $exchange = $channel.declare-exchange('logs', 'fanout').result;
    $exchange.publish(body => $body.encode);
    await $n.close("", "");
    await $con;
}
# vim: expandtab shiftwidth=4 ft=perl6
