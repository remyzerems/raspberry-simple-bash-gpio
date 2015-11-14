# Raspberry Simple Bash GPIO
Linux bash script to easily handle Raspberry GPIO


### Installation
Put the gpio_pin.sh script wherever you need.
And of course, don't forget to give execution rights to the script !
```bash
chmod +x gpio_pin.sh
```

### Basic usage example

Drive the GPIO17 on
```bash
./sh gpio_pin.sh 17 on
```

Drive the GPIO17 off
```bash
./sh gpio_pin.sh 17 off
```

Toggle the GPIO17
```bash
./sh gpio_pin.sh 17 toggle
```

Get the GPIO17 status
```bash
./sh gpio_pin.sh 17 status
```

Drive the GPIO17 on immediately (i.e. with no security lock)
```bash
./sh gpio_pin.sh 17 on -u
```