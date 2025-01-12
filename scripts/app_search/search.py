#!/usr/bin/python3
# coding : utf-8

import argparse, logging, sys
from main import SearchPrompt
from termcolor import colored

def check_args(_agrs=None):
    
    # Init Argparse
    parser = argparse.ArgumentParser(description='Search book')
    
    parser.add_argument('-s', '--show', action="store_true", help="Show categories avalaible")
    parser.add_argument('-c', '--category', type=str, metavar='category', help="Category")
    parser.add_argument('-v', '--verbose', action='store_true', help="Mode verbose")
    parser.add_argument('-d', '--debug', action='store_true', help="Mode debug")

    args = parser.parse_args()

    return args

def main():

    # Init Logger
    logger = logging.getLogger()
    logging.basicConfig(format='%(levelname)s :: %(message)s')

    check_args(sys.argv[1:])

    SearchPrompt().cmdloop()

if __name__ == "__main__":

    main()