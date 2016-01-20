#!/usr/bin/env perl6

use Net::AMQP;

multi sub MAIN(Str $body = ('a' .. 'z').pick(8).join('')) {
    my $n = Net::AMQP.new;
    my $con =  await $n.connect;
    my $channel = $n.open-channel(1).result;;
    $channel.exchange.result.publish(routing-key => "task_queue", body => $body.encode, :persistent);
    await $n.close("", "");
    await $con;
}
# vim: expandtab shiftwidth=4 ft=perl6
