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
	def connectionMade(self):
		self.transport.write("connection made\r\n")

	def dataReceived(self, data):
		"""
		As soon as any data is received, write it back.
		"""
		self.transport.write(data)


def main():
	
	for arg in sys.argv:
		if arg == "server.py":
			continue 
	##########
	# ALFORD below
	##########
		elif arg == str(PORT_NUM['ALFORD']):
			print arg 
			f = Factory()
			f.protocol = Echo
			reactor.listenTCP((PORT_NUM['ALFORD']), f)
			reactor.run()
	##########
	# BALL below
	##########
		elif arg == str(PORT_NUM['BALL']):
			print arg 
			f = Factory()
			f.protocol = Echo
			reactor.listenTCP((PORT_NUM['BALL']), f)
			reactor.run()	##########
	# HAMILTON below
	##########
		elif arg == str(PORT_NUM['HAMILTON']):
			print arg 
			f = Factory()
			f.protocol = Echo
			reactor.listenTCP((PORT_NUM['HAMILTON']), f)
			reactor.run()
	##########
	# HOLIDAY below
	##########
		elif arg == str(PORT_NUM['HOLIDAY']):
			print arg 
			f = Factory()
			f.protocol = Echo
			reactor.listenTCP((PORT_NUM['HOLDAY']), f)
			reactor.run()
	##########
	# WELSH below
	##########
		elif arg == str(PORT_NUM['WELSH']):
			print arg 
			f = Factory()
			f.protocol = Echo
			reactor.listenTCP((PORT_NUM['WELSH']), f)
			reactor.run()
		else:
			print "boo"

	#f = Factory()
	#f.protocol = Echo
	#reactor.listenTCP(8000, f)
	#reactor.run()

if __name__ == '__main__':
    main()

