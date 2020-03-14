# EEPROM_Data_Logger
The DE2-115 FPGA board reads in data through a 10-bit ADC using SPI, buffers, and writes 64 bytes at a time to the EEPROM using I2C. Then, data is read from the EEPROM with a basic bit banging program on an Arduino. Sample rate ~6000/sec with resolution of 8 bits.

[Click image to see youtube demonstration](https://github.com/tymcgrew/EEPROM_Data_Logger/blob/master/misc/plot.png)](https://youtu.be/RKF3j1R-JCc)

[![Demonstration](https://github.com/tymcgrew/EEPROM_Data_Logger/blob/master/misc/plot.png)](https://youtu.be/RKF3j1R-JCc)

[Additional information can be found in the project report](https://github.com/tymcgrew/EEPROM_Data_Logger/blob/master/misc/Project%20Report.pdf)
