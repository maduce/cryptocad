cryptocad
=========

Applications for scrambling and/or encrypting your CAD files.


***Note:*** step files are currently the only formats supported. IGES and STL next. This is still very much a work in progress. Stay tuned for more.

#### Usage
To Scramble:
 ```bash
:~$ sh step_functions.sh scramble 3 file.step
```
The scrambled file will be in output.step.  To unscramble the output file:
```bash 
:~$ sh step_functions.sh descramble 3 output.step
```
***Note:*** you must use the same number for descrambling that you used for scrambling.

