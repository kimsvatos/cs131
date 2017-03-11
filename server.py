#!/usr/bin/env python
#!/usr/bin/env python

# Copyright (c) Twisted Matrix Laboratories.
# See LICENSE for details.

from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
import sys, time, json
from twisted.protocols.basic import LineReceiver

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

SERV_RELATIONSHIP = {
	'ALFORD' : ['HAMILTON', 'WELSH'],
	'BALL' : ['HOLIDAY', 'WELSH'],
	'HAMILTON' : ['ALFORD', 'HOLIDAY'],
	'HOLIDAY' : ['BALL', 'HAMILTON'],
	'WELSH' : ['ALFORD', 'BALL']
}


### Protocol Implementation

# This is just about the simplest possible protocol

class Prop(Protocol):
	def __init__(self, message):
		self.message = message
	def connectionMade(self):
		self.transport.write(self.message)
		self.transport.loserConnection()



class PropFactory(Factory):
	#def startedConnecting(self, connector):
#	return 
	
	def __init__(self, message, lFile):
		self.message = message
		self.lFile = lFile

	def startedConnecting(self, conn):
		return
	def buildProtocol(self, port):
		return Prop(self.message)

	def clientConnectionLost(self, conn, why):
		self.lFile.write("Propogation connection lost because: {0}\n".format(why))

	def clientConnectionFailed(self, conn, why):
		self.lFile.write("Propogation connection failed with error: {0}\n".format(why))




class Server(LineReceiver):
	def __init__(self, factory):
		self.name = None
		self.factory = factory
		self.clients = factory.clients
		self.serverName = factory.name
		self.lFile = factory.lFile
		self.servList = SERV_RELATIONSHIP[self.serverName]


	def connectionMade(self):
		print("connectionMade!")
		self.factory.numConn += 1
		note = "Connection made, total connections = {0}".format(self.factory.numConn)
		self.sendLine(note)
		self.lFile.write(note + "\n")

	def processError(self, line, error):
		note = "ERROR: " + line
		self.sendLine(note)
		self.lFile.write()

	def lineReceived(self, line):
		"""
		As soon as any data is received, write it back.
		"""
		print("lineReceived!")
		if len(line) == 0:
			self.processError(line, "Line empty")
			return

		data = line.strip()
		msg = data.split()
		if len(msg) < 4: #number of args we need
			self.processError(data, "Must have 4 args")
			return

		self.lFile.write("Client sent: " + data + "\n")

		if msg[0] == "IAMAT":
			print("we got an IAMAT!")
# TODO
			self.handle_IAMAT(msg)
		elif msg[0] == "AT":
			print("we got an AT!")
#TODO
			self.handle_AT(msg)
		elif msg[0] == "WHATSAT":
			print("we got a WHATSAY!")
#TODO
			self.handle_WHATSAT(msg)
		else:
			self.processError(data, "Invalid option: must use IAMAT or WHATSAT.")

		def splitLoc(self, loc):
			loc = loc.replace("-", " -")
			loc = loc.replace("+", " +")
			loc = loc.split()
			return loc


		def flood(self, message, fromServer, exProp = True):
			for serv in self.servList:
				if exProp or serv != fromServer:
					self.lFile.write("Attempt to propogate info to " + serv + "\n")
					reactor.connectTCP("localhost", PORT_NUM[serv], PropFactory(message, self.lFile))

		def handle_IAMAT(self, message):
			print("trying to handle iamat!")
			if len(message) != 4:
				self.processError(" ".join(message), "IAMAT takes 4 args")
			if "-" not in message[2] and "+" not in message[2]:
				self.processError(" ".join(message), "Improper location, must have + or -")
			self.name = message[1]
			loc = message[2]

			loc = self.splitLoc(loc)
			if len(loc)!= 2:
				self.processError(" ".join(message), "Must have 2 location parameters")
				return
			#can use helper
			try:
				testloc1 = float(loc[0])
				testloc2 = float(loc[1])
			except:
				self.processError(" ".join(message), "invalid location")
				return

			ctime = message[3]
			#can use helper
			try:
				testTime = float(ctime)
			except:
				self.processError(" ".join(message), "invalid time")
				return
	



			data = " ".join(message[1:])
			self.clients[self.name] = data
			atMessage = self.makeATstring(ctime, data)
			self.sendLine(atMessage)
			self.lFile.write("Server responds: " + atMessage + "\n")
			self.flood(atMessage, "Client", False)


		def makeATstring(self, ctime, data):
			print("tying to make at string!")
			timeChange = time.time() - float(ctime)
			timeChange = str(timeChange)
			if timeChange[0] != '-':
				timeChange = "+" + timeChange

			return "AT " + self.serverName + " " + timeChange + " " + data

		def handle_AT(self, message):
			print("trying to handle at!")
			if len(message) != 6:
				self.processError(" ".join(message), "AT requires 6 parameters")
				return

			orig = message[1]
			if orig not in PORT_NUM:
				self.processError(" ".join(message), "Unrecognized server name")
				return

			clientName = message[3]
			ctime = message[-1]
			try:
				testTime = float(ctime)
			except:
				self.processError(" ".join(message), "Invalid time")
				return

			data = " ".join(message[3:])
			oldATstring = " ".join(message)
			message[1] = self.serverName
			newATstring = " ".join(message)

			if c not in self.clients:
				self.clients[client] = data
				self.lFile.write("Received Prop: " + oldATstring + "\n")
				self.flood(newATstring, orig, False)
			elif self.clients[client] != data:
				sTime = self.clients[client].split()
				sTime = sTime[-1]
				if float(sTime) < float(ctime):
					self.clients[client] = data
					self.lFile.write("Received Prop: " + " ".join(message) + "\n")
					self.flood(newATstring, orig, False)

		def handle_WHATSAT(self, message):
			print("trying t ohandle whatsay!")
			if len(message)!= 4:
				self.processError(" ".join(message), "WHATSAT requires 4 parameters")
				return

			client = message[1]
			if client not in self.clients:
				self.processError(" ".join(message), "Invalid client")
				return
			rad = message[2]
			limit = message[3]
			try:
				rad = float(rad)
				rad *= 1000
			except:
				self.processError(" ".join(message), "Radius is incorrect format")
				return
			try:
				limit = int(lim)
			except:
				self.processError(" ".join(message), "Upper Bound Limit is incorrect format")
				return

			if rad <= 0 or rad > 50:
				self.processError(" ".join(message), "Radius in incorrect range")
				return
			if limit <=0 or limit >20:
				self.processError(" ".join(message), "Upper Bound Limit in incorrect range")
				return

			data = self.clients[client].split()
			loc = self.splitLoc(loc)
		
			url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={0},{1}&radius={2}&types=food&name=cruise&key={3}".format(loc[0], loc[1], rad, API_KEY)
			pageGot = getPage(url).addCallback(self.handl_JSON, limit=limit, client=client)
			pageGot.addErrBack(self.handle_GOOGERR, message=message)

		def handle_JSON(self, data, limit, client):
			print("chandling json!")
			placejson = json.loads(data)
			placejson["results"] = placejson["results"][:limit]
			jsonBLOB = json.dumps(placejson, indent = 3, separators = (',', ': '))
			savedData = self.clients[client]
			ctime = savedData.split()[-1]
			res = self.makeATstring(ctime, savedData) + "\n" + jsonBLOB
			res = res.rstrip("\n") + "\n\n"
			self.transport.write(res)
			self.lFile.write("server responds : " + res + "\n")

		def handle_GOOGERR(self, err, message):
			self.processError(" ".join(message), err)


class ServFactory(Factory):
	numConn = 0
	def __init__(self, name):
		self.name = name
		self.log = name + "Log.txt"
		self.clients = {}

	def buildProtocol(self, port):
		print("tryna build prtocol!")
		return Server(self)

	def startFactory(self):
		print("startin factory!")
		self.lFile = open(self.log, "a")
		self.lFile.write("Creating log for {0} \n".format(self.name))

	def stopFactory(self):
		self.lFile.close()


def main():
	
	if len(sys.argv) != 2:
		sys.stderr.write("Must have 2 arguments.\n")
		exit(1)

	servName = sys.argv[1]
	print(sys.argv[1])
	if servName in PORT_NUM:
		print("yes!")
		portNumber = PORT_NUM[servName]
		reactor.listenTCP(portNumber, ServFactory(servName))
		reactor.run()
	else:
		sys.stderr.write("Server name not valid.\n")
		exit(1)


	#f = Factory()
	#f.protocol = Echo
	#reactor.listenTCP(8000, f)
	#reactor.run()

if __name__ == '__main__':
    main()

