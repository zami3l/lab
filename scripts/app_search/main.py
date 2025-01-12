#!/usr/bin/python3
# coding : utf-8

from cmd import Cmd
from category import validCategory, list_category
from protocol import validProtocol, list_protocol
from termcolor import colored

class SearchPrompt(Cmd):

     prompt = "> "
     intro = (colored("""\
................................................
..%%%%...%%%%%%...%%%%...%%%%%....%%%%...%%..%%.
.%%......%%......%%..%%..%%..%%..%%..%%..%%..%%.
..%%%%...%%%%....%%%%%%..%%%%%...%%......%%%%%%.
.....%%..%%......%%..%%..%%..%%..%%..%%..%%..%%.
..%%%%...%%%%%%..%%..%%..%%..%%...%%%%...%%..%%.
................................................ v1.0""", 'blue', attrs=['bold']))+colored("\n\n=> Tool for searching exploit.\n   Hack The World and Enjoy è_é\n", 'red', attrs=['bold'])

     def __init__(self):
          Cmd.__init__(self)

     def do_exit(self, inp):
          print(colored("Exit...", 'yellow', attrs=['bold']))
          return True
 
     def do_cat(self, inp):
          list_category()

     def do_prot(self, inp):
          list_protocol()