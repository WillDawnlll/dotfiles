#!/bin/bash
killall barriers;
barriers --daemon --disable-client-cert-checking --address :24800 -c ~/barrier.conf --log ~/barrier.log
