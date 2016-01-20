#!perl6

# This does the same as the "printer.pl6" but
# uses the react construct

use v6;

use Net::AMQP;

my $n = Net::AMQP.new;

my $connection = $n.connect.result;

react {
    whenever $n.open-channel(1) -> $channel {
        whenever $channel.declare-exchange('logs', 'fanout') -> $exchange {
            whenever $channel.declare-queue("") -> $queue {
                await $queue.bind('logs');
                $queue.consume;
                my $body-supply = $queue.message-supply.map( -> $v { $v.body.decode }).share;
                whenever $body-supply -> $message {
                    say $*PID ~ " : " ~ $message;
                }
                whenever $body-supply.grep(/^exit$/) {
                    say $*PID ~ " exiting";
                    $n.close("", "");
                    done();
                }

            }
        }
    }
}

await $connection;
