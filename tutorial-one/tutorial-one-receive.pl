#!perl6

# This does the same as the "printer.pl6" but
# uses the react construct

use v6;

use Net::AMQP;

my $n = Net::AMQP.new;

my $connection = $n.connect.result;

react {
    whenever $n.open-channel(1) -> $channel {
        whenever $channel.declare-queue("hello") -> $q {
            $q.consume;
            whenever $q.message-supply.map( -> $v { $v.body.decode }) -> $message {
                say $message;
                $n.close("", "");
                done();
            }
        }
    }
}

await $connection;
