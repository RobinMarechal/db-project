#!/bin/bash

check_term() {
if [[ ! -v NO_TERM ]]; then
	if [ ! -t 0 ]; then
		xterm -hold -e "bash $0"
	fi
fi
}
