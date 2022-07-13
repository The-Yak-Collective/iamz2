#! /bin/bash
#this script starts up all the various functions of the rover, including self-test. basically - BOS (Bos Operating System)
#now drafted in the form of one script, but for modularity reasons, some parts should be in separate files (to make them easy to re-run when a prerequisite comes up)
#also need to define what is MINWORKS - what is minimum and how is it decided

#open question - how do we define preparedness of rover. on the one hand, there is a minimum. on the other, if something does not work, that is simply a new configuration

#need env variables?
cd $IAMZ2_DIR/startup 
STARTUPLOG="startuplog"$(date "+%s")
exec 1>STARTUPLOG 2>&1
source $IAMZ2_DIR/.env


#do some basic integrity checks - maybe move some items from below to here
    #check checksums 
#while i want to check integrity against external blockchain, we cannot hang on lack of network and just need to trust checksum
#check s/w components exist, checksums (integrity level 1 testing)
source integritychecks1.bash
INTLEVEL=3 #integrity level 1 to 10 where 1 is lowest, 10 is highest

#select startupscript if set ahead of time and also according t simple logic - like "how long was i out for and was it planned" - do we maybe read it from blockchain?
#no file exists for now. also not clear if we do script selection here or later
    #check whenami (vs. plan)
if test -f "starthere.bash"; then
    source starthere.bash
    exit
fi
#start basic services
cd $IAMZ2_DIR/rpcservices
    #start motor service(s) (rag)
nohup /usr/bin/python3 ragrpc.py &
    #start sensor service(s) (cam)
#nohup /usr/bin/python3 camrpc.py & # no camera module yet
    #start logger service
nohup /usr/bin/python3 logrpc.py &
    #start other basic h/w interfacing stuff
nohup /usr/bin/python3 imurpc.py &
nohup /usr/bin/python3 legsrpc.py &
    #start safety lock to prevent movement
#/usr/bin/python3 $IAMZ2_DIR/llcommands/freeze.py #does not exist yet
#start communication connectivity
#check re internet connection - wifi, etc. 
##what if we fail? lets say there is a background check every X seconds. and when it works, it redoes this section, so section should be in its own file
#for now, we let OS handle connectivity and all the connectivity based services will need to know how to pause until/react when they get internet. or just soft fail (like twitter rover saying "hello"
#    HAVENET=true

#blockchain - a stand in for a general server
#start blockchain node
cd $IAMZ2_DIR/blockchain
source startblockchain.bash
    #read special startup instructions from blockchain?
    #do integrity test against blockchain
    #report to blockchain the results (including checksum), so others know i can be trusted
    #how low a level of the OS is the blockchain?
cd $IAMZ2_DIR/startup
source integritychecks2.bash #if blockchain not up (should also be an RPC service) setup background process to poll and then apply test!
#start secondary s/w components

    #not clear which ones, yet

    
#start self-configuration. testing and reconfiguring can be mission specific. how to do?
#perhaps some of this is skipped based on the type of on-off cycle. and we have a more minimal check to see nothing changed. in any case, we have some sort of ongoing "did h/w change"
cd $IAMZ2_DIR/startup
#source whoami.bash #some basic identity check
#source whatami.bash #what type of bot - download conf file from blockchain

    #identify components (how do we make architecture discoverable) and self name

    #for each component run its own self-check
    #additional self checks, as defined. esp. for combinations of components (e.g., whole leg, coordination, etc)

    #test actuators by moving, a tiny bit - dangerous and requires freeze release
    #test/configure inert parts, using other sensors on rover

#check higher level integrity - using blockchain here could be interesting

    #security system startup
    #malicious code (what is that beyond viruses? maybe that commands do what you expect and so do sensors?)
    #autonomy (not clear how you check the integrity of this. and can it be done this stage of process)
    INTLEVEL=4
    
#do the configuration - there is something deeper here about configuration management and inheritance
    #reconfigure based on results - should drivers be like in s/w (very modular) or are robotic drivers more complex or more integrated into s/w or BOS than standard OS drivers?
    #build self model - format and contents not clear yet,  - is it just uploading a library(s)/package or is it a configuration file? how do we reconfigure other s/w to match model? OR maybe we have a standard model and we overload it based on changes (like loading a "missing leg" package)
    #define movement limits based on self-model

#start higher level s/w components

    
    
    #start continuous-learning module - now or later?
    
    #start continuous discovery adapter module - a layer which translates component protocol into a protocol which can be used immediately (any command does something) and has small steps towards greater use

#start higher behavioral components

    #start "i have rhythm"
    
    #start "location sense"
    
    #start SLAM or the like
    
    #start "posture sense"
    
    #start senseofself/identity
    
    #start emotion/mood system(?) wants are these or maybe they feed off of them
    
    #start watchdogs (some generate alerts and some do things)
    
    #setup error recovery routines
    
#start "environment sensing"
    
#evaluate physical safety 
    #check power level (voltage as a proxy for power levels)
    #check environment ("weather")
    #bootstrap situation construction
    #check posture
    #check posture/location risk = am i about to fall off the table
    #check for (and handle) alerts
    #generate risks profile (what to be scared of + what alerts are needed)


    
#now start doing things

    #sync blockchain - needs wifi
        #recheck checksums, etc. against remote blockchain
        INTLEVEL=5
    #look for orientation landmarks, including ones set before "off" (so what does shutdown process look like, or ongoing "store state" process)
    #generate position estimate (exact or generalized info about)
    #local whereami - clearence within reach
    #release safety lock
    
    
#start command stuff
    #check for ongoing mission
        #mission specific checkup
        #maybe a smart contract on blockchain?
    #check for incoming messages
    #integrate inputs and decide on priorities

#start accepting commands only if $HAVENET is true. or something and only after everything works. or maybe just do not have network and will let OS handle that. only thing we need network for is to say "hello"
    if $HAVENET ; then
    #start connection to base station, other remote monitor controller

    #start pagekite

    #start webserver 
    
    #start discord client
    
    #start human interface TBD if it is even part of BOS (lets say a dialog chatbot)
    #start "social sense"
        #check social network (who is up, etc.) - requires wifi
        #chack whoamitoothers vs. whoamitoself
    fi

#all (or enough) is working. so release rover

if $MINWORKS; then
#start "what do i do now script"
fi 
#what do we do if not?
    