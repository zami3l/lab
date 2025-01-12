#!/usr/bin/python3
# coding : utf-8

import toml, os

fileProtocol = os.path.abspath('list/protocol.toml')
validProtocol = {}

class Protocol():

    def __init__(self, _name, _port, info):

        self.name = _name
        self.port = _port
        self.info = info

def list_protocol():

    print("List of protocols :")
    for index, items in enumerate(validProtocol.keys()):
        print("[{}] => {}".format(index, items))

#Read file toml Protocol
listProtocol = toml.load(fileProtocol)

for index in listProtocol.keys():
    validProtocol[index] = Protocol(listProtocol[index]['name'], listProtocol[index]['port'], listProtocol[index]['info'])