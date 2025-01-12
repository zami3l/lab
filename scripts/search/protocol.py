#!/usr/bin/python3
# coding : utf-8

import toml

fileProtocol = 'list/protocol.toml'

class Protocol():

    def __init__(self, _name, _port, _description):

        self.name = _name
        self.port = _port
        self.description = _description

#Read file toml Protocol
listProtocol = toml.load(fileProtocol)

validProtocol = {}

for index in listProtocol.keys():
    validProtocol[index] = Protocol(listProtocol[index]['name'], listProtocol[index]['port'], listProtocol[index]['description'])