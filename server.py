#!/usr/bin/env python
#!/usr/bin/env python

# Copyright (c) Twisted Matrix Laboratories.
# See LICENSE for details.

from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
import sys

# Google Places API key
API_KEY="AIzaSyCguQHLUOCn_G_YADwcoW-qxIneZkLbCRo"

# TCP port numbers for server instances
# Please use the port numbers allocated by the TA.
PORT_NUM = {
    'ALFORD': 12688,
    'BALL': 12689,
    'HAMILTON': 12690,
    'HOLIDAY': 12691,
    'WELSH': 12692
}




### Protocol Implementation

# This is just about the simplest possible protocol
class Echo(Protocol):
    def dataReceived(self, data):
        """
        As soon as any data is received, write it back.
        """
        self.transport.write(data)


def main():
	
	for arg in sys.argv:
		if arg == "server.py":
			continue 
		elif arg == PORT_NUM['ALFORD']:
			print arg 

	f = Factory()
	f.protocol = Echo
	reactor.listenTCP(8000, f)
	reactor.run()

if __name__ == '__main__':
    main()

