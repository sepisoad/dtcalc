dtcalc (date/time calculator)
======

dtcalc is a simple command line date/time calculator licensed under GPL v3.

you can add numbers to or remove numbers from current or some arbitrary dates and see the result.
the same thing applies to time.

i wrote this tool just to learn scheme! so if you see some stupid codes don't blame me, 
scheme looks fucking confusing to me but that's okey

for complete list of options please use -h or --help switch:

:) dtcalc -h

as mentioned before dtcalc is written completely in scheme, I use chicken compiler and also some of the chicken eggs! 
and extensions to make the code simpler and smaller and also easier to port. but that makes the code to compile only 
nder chicken compiler and to be honest this is the most notable scheme problem since there are multiple standards for it. 

but don't worry, one of the reason I chode chicken was that it produces small and fast code and it works on almost all
alive platforms including linux, bsd, mac, haiku and well ... fucking vindooz.

In order to compile the code in other scheme compilers like guile, chibit, etc you have to change some parts 
of the code (most of the code!). 

BTW, if you have any question send me an email (sepehr.aryani@gmail.com)
...
