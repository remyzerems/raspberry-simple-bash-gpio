#!/bin/bash

# This script is a modification of the script presented here : http://tech.iprock.com/?p=10030
# The changes made are the IO pin parametrization
# To run this script use :
#  - To drive the GPIO17 pin of the Raspberry Pi ON : sh drive_io_pin.sh 17 on
#  - To drive the GPIO17 pin of the Raspberry Pi OFF with no security locking : sh drive_io_pin.sh 17 on -u

# Function to handle an invalid option error
invalid_option_error ()
{
	echo "Invalid option - use on, off, toggle, or reboot."
    exit
}

# Check that the first argument is a number (i.e. a pin number)
# Be careful since it does not check that the pin number is a valid pin number
case $1 in
    ''|*[!0-9]*) echo "Error: $1 is not a number" >&2; exit 1 ;;
    *)  ;;
esac

# Check that the the second argument has been given
if [ -z $2 ]
then
    invalid_option_error
else
    opt=$2
fi

# By default, use the security locking mode
locking=1
if [ -n $3 ]
then
	if [ $3 = "-u" ]
	then
		# Excepted if the -u option is specified
		locking=0
	fi
fi

# If security locking has been asked
if [ $locking -eq 1 ]
then
	# Sleep for a random while
	let "sleep = $RANDOM + 10000"
	sleep "0.$sleep"

	# If the script is already running, exit
	if [ $(pgrep $0|wc -w) -gt "2" ]; then
		exit
	fi
fi

# Check that the IO direction has correctly been set
if [ ! -e "/sys/class/gpio/gpio$1/value" ]
then
	# If not, configure it correctly
    echo "$1" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio$1/direction
fi

# Manage options
case $opt in
    on)
        echo 1 > /sys/class/gpio/gpio$1/value
        ;;
    off)
        echo 0 > /sys/class/gpio/gpio$1/value
        ;;
    toggle)
        value=`cat /sys/class/gpio/gpio$1/value`
        if [ $value -ne 0 ]
        then
            echo 0 > /sys/class/gpio/gpio$1/value
        else
            echo 1 > /sys/class/gpio/gpio$1/value
        fi
        ;;
    reboot)
        echo 0 > /sys/class/gpio/gpio$1/value
        sleep 30
        echo 1 > /sys/class/gpio/gpio$1/value
        ;;
    status)
        cat /sys/class/gpio/gpio$1/value
		exit
        ;;
    *)
        invalid_option_error
        ;;
esac

# If the security locking mode has been selected
if [ $locking -eq 1 ]
then
	# Wait a little bit to ensure this script cannot be run too often
	sleep 3
fi
