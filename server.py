#!/usr/bin/env python
from twisted.internet.protocol import Protocol


from twisted.internet.protocol import Factory
from twisted.internet.endpoints import TCP4ServerEndpoint
from twisted.internet import reactor


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

class myProt(Protocol):
	def connectionMade(self, addr):
		self.transport.write("I connected to a prot!")


class myFactory(Factory):
	def buildProtocol(self, addr):
		return myProt()


endpoint = TCP4ServerEndpoint(reactor, 12688)
endpoint.listen(myFactory())
reactor.run()