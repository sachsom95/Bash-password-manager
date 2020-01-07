# Bash-password-manager
A general password manager application to understand bash
Users will be able to store and retrieve passwords via a command-line interface (CLI), with front end made of a client that passes commands to a server to retrieve or edit information

This document contains information regarding the architecture of the program, implementation, challenges faced, concepts used, possible bugs and additional implementations for the program.

<h3>Architecture</h3>
The password manager consists of 3 blocks.
<li>
  Client - The user-facing interface where all the instructions are passed and messages are received.</li>
<li> Server - The backend which receives data from the client and calls the scripts</li>
<li> Scripts - The files which contain individual programs which make up the system</li>
<li> Pipes - Interprocess communication channels used to transfer data from Client to Server to scripts and back to the client. Here it must be mentioned that named pipes are used for IPC than normal bash pipes.</li>


<h3>DESIGN CHALLENGES</h3> 

During the development of the project, each new script brought new challenges, difficulties, and solutions. The next section is devoted to present all the observations
Scripts
<li>Init.sh</li>
The init.sh script is used to create a directory which represents a user; The script is designed to accept only one parameter which is the name of the user and must be passed in the client as 

    ./init.sh $username 
                
This was the first script to be implemented, concepts such as argument passing and numbering of parameters were used. Learned how to use comparison operators and conditions in bash. The script was straight forward and no possible bugs or issues where observed. The script needed to be modified later to include semaphores to allow only one user to make a file at a time. At times it is observed that after making users concurrently the symbolic link used doesn’t get removed. This doesn’t occur most of the time to find out the reason, but when it does occur I have to manually remove the lock created.

<li>Insert.sh</li>
The insert.sh script is used to create services inside user directories; The script was initially designed to accept only 3 parameters the username, service and the payload.

    ./insert.sh $user $service $payload
      
The main problem faced in developing the script was in parsing the arguments received based on ‘/’ , for this internal field separator was used IFS = ’/ ’. This solves most of the issue however the trade-off was that username or payload cannot have ‘/’ as a character. This observation came quite late when I did final testing by that time the entire program used IFS =’ / ‘. In the future, a more robust system by use of SED is planned to be employed. 
Show.sh
In show.sh script the `cat` command was used to display contents from the file the main challenge in this was finding out all different combinations in which parameters for user and service of multiple depths can be passed. 
There might be a chance that I might not have considered a combination of user service combination for parsing parameter however during personal testing there were no issues
<h6>NOTE</h6>
   For show to work properly the service must be first created via client as I have a certain format in which file must be written for show to work properly.		
			
    ./show.sh $user $service

<li>UPDATE SERVICE USING insert.sh</li>
The insert.sh script needs to be modified to accommodate a fourth parameter ‘f’ which if added will edit already existing service and save it. It is my interpretation from the question that either the insert command must have 3 parameters if so it will behave like initially designed insert script else if ‘ f ‘ is added it will edit and save the already existing script. 


<h6>NOTE</h6>

If the normal behavior is to be expected only input 3 parameters instead of four don't add “ ” as the fourth parameter.
                                       
    ./insert.sh user1 Bank/aib.ie f "$payload
						      Or
    ./insert.sh $user $service $payload
    
<li>Rm.sh</li>

This script is used to remove the services , the rm command was used for the removal
		./rm.sh user service
    
<li>Ls.sh</li>

The list command uses the tree command to list all the services which the user-created an interesting observation was the fact that the tree command was not available in mac terminal and therefore had to be installed using homebrew hence I was able to learn homebrew for installation of UNIX packages without worrying about dependencies.

    P.sh and V.sh
    
These are the two files used to maintain semaphore the p.sh is from the modified script from os practical 5. At times I have used p and v to lock sections beyond the critical section. The one drawback to this practice is that in case the script needs to be stopped in between the lock file is not removed and a deadlock situation might arise. 

<h3>SERVER SCRIPT</h3>

The server script consists of an infinitely running while loop with a series of switch cases. The server listens for commands employing a pipe (server.pipe) which will be made at the beginning, if the pipe is not already present. The server will receive a message from the client-side via the server pipe and is parsed and the switch cases will run an appropriate script based on the received command. The message from server.pipe is parsed using IFS. The messages from the server-side to the client-side are passed via named pipes which are unique to the client id sent. In the server, I have put a small sleep between the server.pipe read this is to ensure that the server doesn’t start reading before the client stops writing in the and sends and a close signal to server.pipe. The result was an infinite loop on the server-side. This issue was not reproducible on demand but used to occur frequently hence the small sleep statements, This seems to have stopped the problem. The same problem happened to one of my classmates in the insert part, adding a small delay between read-write operation removed the issue.

<h6>NOTE</h6>

 At times after using the same server.pipe for a large number of times at some point the pipe starts to send command which is partially missing words. I was not able to find out the reason for it and the only solution I could find was to delete the server.pipe and start the server again. Another limitation that was observed in pipes was when I encrypted service files it was observed that long strings where getting cut, after reading some documents the conclusion I can draw is that buffer for pipe will stop at the point where it can no longer guarantee an atomic operation.
Source : https://unix.stackexchange.com/questions/11946/how-big-is-the-pipe-buffer
A possible fix that I have employed is to encrypt only the password so that the string doesn’t become too big from the openssl encryption algorithm.

<li>CLIENT.SH</li>

The client has a similar structure to that of the server. However, it is not running constantly by means of a while loop. Whenever the client is invoked a unique named pipe is made from the client id which is received as a parameter. The clientid.pipe is used to receive information back from the server. 
The client also has some scripts executing in it ; the decrypt script will be invoked one the payload is received from server and password gets decrypted. The edit script is also an interesting section it calls the show command and receives the payload then gets passed to a temporary file using ‘mktemp’ command and vim is called on it. The user can now edit the file and the insert.sh script with ‘f’ parameter gets invoked so that the information gets updated.

An observation while implementing client was effect of using echo and cat to display the contents from pipes it was observed that when cat was used to output the contents of pipe at times the client will continue to run and I had to manually stop the process for this reason most of time contents from pipe are stored in a variable and then displayed using the echo command.
ADDITIONAL IMPLEMENTATION:

Encryption was implemented using openssl algorithm which was provided a number of issues popped up during the implementation , the first issue was “ bad magic number” error this happens because the decrypt script requires a new line to be present in the encrypted password use of echo to write file removes the problem as it automatically adds a new line at the end. Another issue is the problem of outputting special characters into a file using echo. If an encrypted password says has a character ‘/ ’ while writing it to a file it is recognized as a space between character, hence on trying to decrypt an error arises. A possible solution is the use of command -e in echo however upon checking man page in mac bash terminal -e command seems to be missing while -e is present in the terminal in cs server. Therefore -e is used in the echo statement. I was not able to get a proper solution in a Mac environment
Random password was also made an option in the client script.To generate a random password insert command is invoked when the option to input password type “R” and a random password is generated, this will also be encrypted. Random password uses the time as a parameter.

    password=$(date '+%s' )
