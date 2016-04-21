#!/usr/bin/expect -f

set timeout 1800

set command [lindex $argv 0]
set arguments [lrange $argv 1 end]

eval spawn $command $arguments

expect {
    "Do you accept the license '*'*" {
        exp_send "y\r"
        exp_continue
     }
     eof
}
