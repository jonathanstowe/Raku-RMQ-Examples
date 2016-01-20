#!/usr/bin/env perl6

use Net::AMQP;

subset Level of Str where { $_ ~~ any(<debug info warning error fatal>) };

multi sub MAIN(Str $message = 'Hello, World', Level $level = 'info') {
    my $n = Net::AMQP.new;
    my $con =  await $n.connect;
    my $channel = $n.open-channel(1).result;
    my $exchange = $channel.declare-exchange('multi_logs', 'direct').result;
    $exchange.publish(routing-key => $level, body => $message.encode);
    await $n.close("", "");
    await $con;
}
# vim: expandtab shiftwidth=4 ft=perl6
