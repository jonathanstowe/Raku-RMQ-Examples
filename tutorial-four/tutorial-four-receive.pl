#!/usr/bin/env perl6

use v6.c;

use Net::AMQP;

subset Level of Str where { $_ ~~ any(<debug info warning error fatal>) };

multi sub MAIN(*@levels ) {
    my $n = Net::AMQP.new(:debug);
    unless @levels.elems && all(@levels) ~~ Level {
        die "must supply at least one valid level";
    }
    my $connection = $n.connect.result;
    react {
        whenever $n.open-channel(1) -> $channel {
            whenever $channel.declare-exchange('multi_logs', 'direct') -> $exchange {
                for @levels -> $level {
                    my $queue =  $channel.declare-queue('', :exclusive).result;
                    await $queue.bind('multi_logs', $level);
                    $queue.consume;
                    my $body-supply = $queue.message-supply.map( -> $v { $v.body.decode }).share;
                    $body-supply.tap( -> $message {
                            say $*PID ~ " : [$level]  $message";
                    });
                }
            }
        }
    }
    await $connection;
}
# vim: expandtab shiftwidth=4 ft=perl6
