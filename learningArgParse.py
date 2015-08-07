#!/usr/bin/env python
#Peter Frick, Stanford University

import argparse
import sys

parser = argparse.ArgumentParser(description="Description: This is a script that takes reads in string arguments and makes everything uppercase. This is a primer to learning how to properly us argparse")

if len(sys.argv)<2:
        print "need to add arguments!"
	print "type [scriptName.py] -h for documentation"
	quit()

parser.add_argument('strings',type=str,nargs='+',help="This is a variable that I want to operate on")
parser.add_argument('--capitalize','-c',help='Capitalize the string',action='store_true')
parser.add_argument('--nospace','-ns',help='Prints the string with no spaces',action='store_true')
parser.add_argument('--rickroll','-r',help='I think you know what will happen...',action='store_true')
parser.add_argument('--signature','-s',help='string appended to return',default='Sincerely, argbot')
parser.add_argument('--greeting','-g',help='string prefix to return',required=True)


args=parser.parse_args()

a=args.strings

if args.rickroll:
	print "Never gonna give you up"
	quit()

if args.nospace:
        a=''.join(a)
else:
        a=' '.join(a)

if args.signature:
	a=a + '\n' + args.signature

if args.greeting:
	a=args.greeting.upper() + ', \n' + a

if args.capitalize:
	a=a.upper()



print a
