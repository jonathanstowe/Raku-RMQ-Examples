#!/usr/bin/env perl6

use Net::AMQP;


multi sub MAIN(Str $message = 'Hello, World', Str $level = 'application.info') {
    my $n = Net::AMQP.new;
    my $con =  await $n.connect;
    my $channel = $n.open-channel(1).result;
    my $exchange = $channel.declare-exchange('topic-logs', 'topic').result;
    $exchange.publish(routing-key => $level, body => $message.encode);
    await $n.close("", "");
    await $con;
}
# vim: expandtab shiftwidth=4 ft=perl6
