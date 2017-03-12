#!/usr/bin/env python
#!/usr/bin/env python

# Copyright (c) Twisted Matrix Laboratories.
# See LICENSE for details.

from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
import sys, time, json
import conf
from twisted.protocols.basic import LineReceiver
from twisted.web.client import getPage

SERV_RELATIONSHIP = {
	'ALFORD' : ['HAMILTON', 'WELSH'],
	'BALL' : ['HOLIDAY', 'WELSH'],
	'HAMILTON' : ['ALFORD', 'HOLIDAY'],
	'HOLIDAY' : ['BALL', 'HAMILTON'],
	'WELSH' : ['ALFORD', 'BALL']
}


class Server(LineReceiver):
	def __init__(self, factory):
		self.name = None
		self.factory = factory
		self.clients = factory.clients
		self.serverName = factory.name
		self.lFile = factory.lFile
		self.servList = SERV_RELATIONSHIP[self.serverName]


	def connectionMade(self):
		self.factory.numConn += 1
		note = "Connection made, total connections = {0}".format(self.factory.numConn)
		self.sendLine(note)
		self.lFile.write(note + "\n")

	def processError(self, line, error):
		note = "ERROR: " + line
		self.sendLine(note)
		self.lFile.write("error! {0}, server response: {1}".format(error,note))

	def lineReceived(self, line):
		if not len(line):
			self.processError(line, "Line empty")
			return

		data = line.strip()
		msg = data.split()
		if len(msg) < 4: #number of args we need
			self.processError(data, "Must have 4 args")
			return

		self.lFile.write("Client sent: " + data + "\n")
		if msg[0] == "IAMAT":
			self.handleIAMAT(msg)
		elif msg[0] == "AT":
			self.handle_AT(msg)
		elif msg[0] == "WHATSAT":
			self.handle_WHATSAT(msg)
		else:
			self.processError(data, "Invalid option: must use IAMAT or WHATSAT.")



	def flood(self, message, fromServer, exProp = True):
		for serv in self.servList:
			if exProp or serv != fromServer:
				self.lFile.write("Attempt to propogate info to " + serv + "\n")
				reactor.connectTCP("localhost", conf.PORT_NUM[serv], FloodFactory(message, self.lFile))

	def handleIAMAT(self, message):
		if len(message) != 4:
			self.processError(" ".join(message), "IAMAT takes 4 args")
		if "-" not in message[2] and "+" not in message[2]:
			self.processError(" ".join(message), "Improper location, must have + or -")
		
		cmdAT, self.name, loc, ctime = message

		loc = loc.replace("-", " -")
		loc = loc.replace("+", " +")
		loc = loc.split()
		
		if len(loc)!= 2:
			self.processError(" ".join(message), "Must have 2 location parameters")
			return

		try:
			testloc1 = float(loc[0])
			testloc2 = float(loc[1])
		except:
			self.processError(" ".join(message), "invalid location")
			return

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
		timeChange = time.time() - float(ctime)
		timeChange = str(timeChange)
		if timeChange[0] != '-':
			timeChange = "+" + timeChange
		return "AT " + self.serverName + " " + timeChange + " " + data

	def handle_AT(self, message):
		if len(message) != 6:
			self.processError(" ".join(message), "AT requires 6 parameters")
			return

		orig = message[1]
		if orig not in conf.PORT_NUM:
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

		if clientName not in self.clients:
		#	print("adding to self clients")
			self.clients[clientName] = data
			self.lFile.write("Received Prop: " + oldATstring + "\n")
			self.flood(newATstring, orig, False)
		elif self.clients[clientName] != data:
			sTime = self.clients[clientName].split()
			sTime = sTime[-1]
#			print("doing ufnky thing")
			if float(sTime) < float(ctime):
			#	print("saving after float check")
				self.clients[clientName] = data
				self.lFile.write("Received Prop: " + " ".join(message) + "\n")
				self.flood(newATstring, orig, False)

	def handle_WHATSAT(self, message):
		if len(message)!= 4:
			self.processError(" ".join(message), "WHATSAT requires 4 parameters")
			return

		cmdWHATSAT, client, rad, limit = message

		if client not in self.clients:
			self.processError(" ".join(message), "Invalid client")
			return

		try:
			rad = float(rad)
			rad *= 1000
		except:
			self.processError(" ".join(message), "Radius is incorrect format")
			return
		try:
			limit = int(limit)
		except:
			self.processError(" ".join(message), "Upper Bound Limit is incorrect format")
			return

		if rad <= 0 or rad > 50000:
			print(rad)
			self.processError(" ".join(message), "Radius in incorrect range")
			return
		if limit <=0 or limit >20:
			self.processError(" ".join(message), "Upper Bound Limit in incorrect range")
			return

		data = self.clients[client].split()
		loc = data[1]
		loc = loc.replace("-", " -")
		loc = loc.replace("+", " +")
		loc = loc.split()
		
		url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={0},{1}&radius={2}&key={3}".format(loc[0], loc[1], rad, conf.API_KEY)
		data = getPage(url)
		data.addCallback(self.callback_JSON, limit=limit, client=client)
		

	def callback_JSON(self, data, limit, client):
		placejson = json.loads(data)
		placejson["results"] = placejson["results"][:limit]
		jsonBLOB = json.dumps(placejson, indent = 4, separators = (',', ': '))
		savedData = self.clients[client]
		ctime = savedData.split()[-1]
		res = self.makeATstring(ctime, savedData) + "\n" + jsonBLOB
		res = res.rstrip("\n") + "\n\n"
		self.transport.write(res)
		self.lFile.write("Server responds :\n " + res + "\n")


class ServFactory(Factory):
	numConn = 0
	def __init__(self, name):
		self.name = name
		self.log = name + "Log.txt"
		self.clients = {}

	def buildProtocol(self, port):
		return Server(self)

	def startFactory(self):
		self.lFile = open(self.log, "a")
		self.lFile.write("Creating log for {0} \n".format(self.name))

	def stopFactory(self):
		self.lFile.close()



class Flood(Protocol):
	def __init__(self, message):
		self.message = message
	def connectionMade(self):
		self.sendLine(self.message)
		self.transport.loseConnection()


class FloodFactory(Factory):
	def __init__(self, message, lFile):
		self.message = message + "\r\n"
		self.lFile = lFile

	def startedConnecting(self, conn):
		return
	def buildProtocol(self, port):
		return Flood(self.message)

	def clientConnectionLost(self, conn, why):
		self.lFile.write("Propogation connection lost because: {0}\n".format(why))

	def clientConnectionFailed(self, conn, why):
		self.lFile.write("Propogation connection failed with error: {0}\n".format(why))


def main():
	
	if len(sys.argv) != 2:
		sys.stderr.write("Must have 2 arguments.\n")
		exit(1)

	servName = sys.argv[1]
	if servName in conf.PORT_NUM:
		portNumber = conf.PORT_NUM[servName]
		reactor.listenTCP(portNumber, ServFactory(servName))
		reactor.run()
	else:
		sys.stderr.write("Server name not valid.\n")
		exit(1)


if __name__ == '__main__':
    main()

