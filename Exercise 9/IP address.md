# Considering the IP address/CIDR of 193.16.20.35/29

* What is the Network IP
* Number of hosts
* Range of IP addresses
* Broadcast IP from this subnet

Subnet Verification Link click me!

### Solution:

To solve this you have to find out what's the subnet mask from the given CIDR (/29)

The network component of the IP address is indicated by the total number of active bits (1s) in the CIDR, whereas the host portion of the network is shown by the 0s.

#### Converting it to binary:

#### Network Portion: 1's

#### Host Portion: 0's

#### Netmask Binary: 11111111.11111111.11111111.11111000

Apply the following formula to convert the subnet mask address from binary to decimal.

There are just 1s and 0s in the binary system. They receive various values according to where they are in the octet. Every place is a power of two. You must add together those numbers to obtain the decimal value.

|First Octet   | Second Octet   | Third Octet	| Fourth Octet   |	Fifth Octet   |	Sixth Octet   |	Seventh Octet   |	Eight Octet|
| -----        | -----          | -----       | -----          | -----          | -----         | ----            | -----      |
|2^7	         |2^6	            |2^5	        |2^4             |2^3             |2^2            |2^1              |2^0         |
|128   	       |64	            |32           |	16	           |8	              |4              |2                |1           |

Total no. of octets in binary: 128 + 64 + 32 + 16 + 8 + 4 + 2 + 1

                        = 255

## First Octet:

| First Octet  | Second Octet  | Third Octet  |	Fourth Octet  |	Fifth Octet  |	Sixth Octet  |	Seventh Octet  |	Eight Octet|
| -----        | -----         | -----        | -----         | -----        | -----         | -----           | -----       |
|128	         |64             |32	          |16             |8             |4              |2                |1            |
|1	           |1	             |1             |1              |1	            |1             |1                |1            |

Total: 255

## Second Octet:

| First Octet  | Second Octet  | Third Octet  |	Fourth Octet  |	Fifth Octet  |	Sixth Octet  |	Seventh Octet  |	Eight Octet|
| -----        | -----         | -----        | -----         | -----        | -----         | -----           | -----       |
|128	         |64             |32	          |16             |8             |4              |2                |1            |
|1	           |1	             |1             |1              |1	            |1             |1                |1            |

Total: 255

## Third Octet:

| First Octet  | Second Octet  | Third Octet  |	Fourth Octet  |	Fifth Octet  |	Sixth Octet  |	Seventh Octet  |	Eight Octet|
| -----        | -----         | -----        | -----         | -----        | -----         | -----           | -----       |
|128	         |64             |32	          |16             |8             |4              |2                |1            |
|1	           |1	             |1             |1              |1	            |1             |1                |1            |

Total: 255

## Fourth Octet:

| First Octet  | Second Octet  | Third Octet  |	Fourth Octet  |	Fifth Octet  |	Sixth Octet  |	Seventh Octet  |	Eight Octet|
| -----        | -----         | -----        | -----         | -----        | -----         | -----           | -----       |
|128	         |64             |32	          |16             |8             |4              |2                |1            |
|1	           |1	             |1             |1              |0	           |0              |0                |0            |

Total: 248

Octet Sum = 255.255.255.248

Therefore 11111111.11111111.11111111.11111000 in binary is = 255.255.255.248

### The wild card must then be located:

Wild card = subtract the subnet mask from 255.255.255.255

      = 255.255.255.255 - 255.255.255.248
      
      = 255 - 248
      
      = 7
      
Wild card = 0.0.0.7

### Next is to find the network ID:
Where

Subnet Mask = 11111111.11111111.11111111.11111000

Given IP = 11000001.00010000.00010100.00100011

Simply do a binary and operation between the provided IP address and the subnet mask to determine the network ID.:

### First Octet:

Binary and operation between (255 & 193) or (11111111 & 11000001)

| N/A          | First Octet   | Second Octet |	Third Octet   |	Fourth Octet |	Fifth Octet  | 	Sixth Octet  | Seventh Octet | Eigth Octet |
| -----        | -----         | -----        | -----         | -----        | -----         | -----         | -----         | -----       |
| Subnet Mask  |1              |1	            |1              |1             |1              |1              |1              |1            |
| Given IP     |1	             |1             |0              |0	           |0              |0              |0              |1            |
| Result       |1              |1             |0              |0             |0              |0              |0              |1            |

Total Sum = 193


### Second Octet:

Binary and operation between (255 & 16) or (11111111 & 00010000)

| N/A          | First Octet   | Second Octet |	Third Octet   |	Fourth Octet |	Fifth Octet  | 	Sixth Octet  | Seventh Octet | Eigth Octet |
| -----        | -----         | -----        | -----         | -----        | -----         | -----         | -----         | -----       |
| Subnet Mask  |1              |1	            |1              |1             |1              |1              |1              |1            |
| Given IP     |0	             |0            |0               |1	           |0              |0              |0              |1            |
| Result       |0              |0            |0               |1             |0              |0              |0              |1            |

Total Sum = 16

### Third Octet:

Binary and operation between (255 & 20) or (11111111 & 00010100)

| N/A          | First Octet   | Second Octet |	Third Octet   |	Fourth Octet |	Fifth Octet  | 	Sixth Octet  | Seventh Octet | Eigth Octet |
| -----        | -----         | -----        | -----         | -----        | -----         | -----         | -----         | -----       |
| Subnet Mask  |1              |1	            |1              |1             |1              |1              |1              |1            |
| Given IP     |0	             |0             |0              |1	           |0              |1              |0              |1            |
| Result       |0              |0             |0              |1             |0              |1              |0              |1            |

Total Sum = 20

### Fourth Octet:

Binary and operation between (248 & 35) or (11111000 & 00100011)

| N/A          | First Octet   | Second Octet |	Third Octet   |	Fourth Octet |	Fifth Octet  | 	Sixth Octet  | Seventh Octet | Eigth Octet |
| -----        | -----         | -----        | -----         | -----        | -----         | -----         | -----         | -----       |
| Subnet Mask  |1              |1	            |1              |1             |1              |0              |0              |0            |
| Given IP     |0	             |0             |1              |0	           |0              |0              |1              |1            |
| Result       |0              |0             |1              |0             |0              |0              |0              |0            |


With that done, The network IP address is 193.16.20.32

### Finding the number of hosts:

Number of Hosts = 2^n - 2

Where n = number of host bits minus two

        = number of host bits - 2

This is due to the fact that the Network and Broadcast IDs are always reserved for the first and final IP addresses, respectively.

### Note: 

Starting from the right, we must count the amount of host bits (0's) in the subnet mask binary, which results in a total of 3.

Number of hosts = 2^3 - 2

            = 8 - 2
            
            = 6

We can then determine the range of IP addresses and the broadcast from the information above:

### Note: 

The network will reserve and broadcast the first and last IP addresses, so:

Given IP: 193.16.20.35/29

Network IP: 193.16.20.32

Number of Hosts: 6

Range of IP Addresses: 193.16.20.33 - 193.16.20.38

min range of IP's = 193.16.20.33
max range of IP's = 193.16.20.38
Broadcast IP: 193.16.20.39
