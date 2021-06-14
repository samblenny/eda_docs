# iCE40 Boards

## Lattice iCE40UP5K Breakout

First attempt at `iceprog -t`:
```
$ iceprog -t
init..
Can't find iCE FTDI USB device (vendor_id 0x0403, device_id 0x6010 or 0x6014).
ABORT.
```

dmesg for iCE40UP5K-B-EVM:
```
[ 2992.540498] usb 2-4: new high-speed USB device number 4 using ehci-pci
[ 2992.701005] usb 2-4: New USB device found, idVendor=0403, idProduct=6010, bcdDevice= 7.00
[ 2992.701009] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2992.701011] usb 2-4: Product: Lattice iCE40UP5K Breakout
[ 2992.701014] usb 2-4: Manufacturer: Lattice
[ 2992.742619] usbcore: registered new interface driver usbserial_generic
[ 2992.742631] usbserial: USB Serial support registered for generic
[ 2992.752070] usbcore: registered new interface driver ftdi_sio
[ 2992.752094] usbserial: USB Serial support registered for FTDI USB Serial Device
[ 2992.752241] ftdi_sio 2-4:1.0: FTDI USB Serial Device converter detected
[ 2992.752278] usb 2-4: Detected FT2232H
[ 2992.753419] usb 2-4: FTDI USB Serial Device converter now attached to ttyUSB0
[ 2992.759150] ftdi_sio 2-4:1.1: FTDI USB Serial Device converter detected
[ 2992.759257] usb 2-4: Detected FT2232H
[ 2992.761642] usb 2-4: FTDI USB Serial Device converter now attached to ttyUSB1
```

Try again with `sudo`:
```
$ sudo iceprog -t 2>&1 | sed 's/flash ID: 0x.*$/flash ID: .../'
init..
cdone: high
reset..
cdone: low
flash ID: ...
cdone: high
Bye.
```

Add udev rule for non-sudo use of iceprog based on instructions at
http://www.clifford.at/icestorm/
```
$ cat <<EOF | sudo tee /etc/udev/rules.d/53-lattice-ftdi.rules
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0660", GROUP="plugdev", TAG+="uaccess"
EOF
```

Unplug and re-plug breakout board so rule will take effect.

Try again:
```
$ iceprog -t 2>&1 | sed 's/flash ID: 0x.*$/flash ID: .../'
init..
cdone: high
reset..
cdone: low
flash ID: ...
done: high
Bye.
```
