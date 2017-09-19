#!/bin/sh

# Script used to setup federated and replica servers.

function usage {
  echo "Usage"
  echo "  setup_replica -C ( Print config file. )"
  echo "  setup_replica config_file [ MASTER_NAME | REPLICA_NAME ] restart ( Restart server. )"
  echo "  setup_replica config_file [ MASTER_NAME | REPLICA_NAME ] setup ( Setup new server. )"
}

function make_config {
  # Print a config file.
  echo "# Server settings for all servers"
  echo "P4USER=user"  
  echo "SERVICE_USER=uservice"
  echo
  echo "# File format:"
  echo "# SERVER_NAME:VAR:VAL"
  echo
  echo "# Master server settings" 
  echo "# SERVER_TYPE = (server, commit-server)"
  echo "MASTER:SERVER_TYPE="
  echo "MASTER:PORT=host:port"
  echo "MASTER:ROOT="
  echo "MASTER:SERVER_NAME="
  echo "MASTER:LOG=log"
  echo "MASTER:DEBUG=3"
  echo "MASTER:MONITOR=2"
  echo "# UNICODE=1 unicode mode"
  echo "MASTER:UNICODE=0"
  echo "# Path to p4d"  
  echo "MASTER:BINARY=/usr/local/bin/p4d"
  echo
  echo "# Replica server settings"
  echo "# Set for edge-server,replica,forwarding-replica,build-server"
  echo "REPLICA1:MASTER_NAME=MASTER"
  echo "# SERVER_TYPE = (edge-server, replica, forwarding-replica, build-server)"
  echo "REPLICA1:SERVER_TYPE="
  echo "REPLICA1:PORT=host:port"
  echo "REPLICA1:ROOT="
  echo "REPLICA1:SERVER_NAME="
  echo "REPLICA1:LOG=log"
  echo "REPLICA1:DEBUG=3"
  echo "REPLICA1:MONITOR=2"
  echo "# UNICODE=1 unicode mode"
  echo "REPLICA1:UNICODE=0"
  echo "# Path to p4d"  
  echo "REPLICA1:BINARY=/usr/local/bin/p4d"
  echo "REPLICA1:PULL_INTERVAL=1"
  echo "REPLICA1:DB_REPLICATION=readonly"
  echo "# LBR_REPLICATION = (readonly,ondemand,none)"  
  echo "REPLICA1:LBR_REPLICATION=readonly"
  exit
}

function read_config {
  # Read the config file.
  CONFIG_FILE=$1
  START_SERVER_NAME=$2
  if [ ! -f $CONFIG_FILE ]
  then
    echo "File '$CONFIG_FILE' does not exist."
    exit
  fi

  START_SERVER_TYPE=NONE
  while read line;
  do
    VAR=`echo $line | cut -d'=' -f1`
    VAL=`echo $line | cut -d'=' -f2`
    VAL=`echo $VAL | cut -d' ' -f1`
    case $VAR in
      "$START_SERVER_NAME:SERVER_TYPE") START_SERVER_TYPE=$VAL;;
      "P4USER") P4USER=$VAL;;
    esac
  done < $CONFIG_FILE

  if [ $START_SERVER_TYPE == "NONE" ]; then
    echo "Server $START_SERVER_NAME not defined in config file."
    exit
  fi

  while read line;
  do
    VAR=`echo $line | cut -d'=' -f1`
    VAL=`echo $line | cut -d'=' -f2`
    VAL=`echo $VAL | cut -d' ' -f1`

    if [ $START_SERVER_TYPE == "server" ] || [ $START_SERVER_TYPE == "commit-server" ]; then
      case $VAR in
        "SERVICE_USER") SERVICE_USER=$VAL;;
        "$START_SERVER_NAME:SERVER_TYPE") MASTER_SERVER_TYPE=$VAL;;
        "$START_SERVER_NAME:PORT") MASTER_PORT=$VAL;;
        "$START_SERVER_NAME:ROOT") MASTER_ROOT=$VAL;;
        "$START_SERVER_NAME:SERVER_NAME") MASTER_SERVER_NAME=$VAL;;
        "$START_SERVER_NAME:LOG") MASTER_LOG=$VAL;;
        "$START_SERVER_NAME:DEBUG") MASTER_DEBUG=$VAL;;
        "$START_SERVER_NAME:MONITOR") MASTER_MONITOR=$VAL;;
        "$START_SERVER_NAME:UNICODE") MASTER_UNICODE=$VAL;;
        "$START_SERVER_NAME:BINARY") MASTER_BINARY=$VAL;;
      esac
    else
      case $VAR in
        "SERVICE_USER") SERVICE_USER=$VAL;;
        "$START_SERVER_NAME:MASTER_NAME") REPLICA_MASTER_NAME=$VAL;;
        "$START_SERVER_NAME:SERVER_TYPE") REPLICA_SERVER_TYPE=$VAL;;
        "$START_SERVER_NAME:PORT") REPLICA_PORT=$VAL;;
        "$START_SERVER_NAME:SERVER_NAME") REPLICA_SERVER_NAME=$VAL;;
        "$START_SERVER_NAME:ROOT") REPLICA_ROOT=$VAL;;
        "$START_SERVER_NAME:LOG") REPLICA_LOG=$VAL;;
        "$START_SERVER_NAME:DEBUG") REPLICA_DEBUG=$VAL;;
        "$START_SERVER_NAME:MONITOR") REPLICA_MONITOR=$VAL;;
        "$START_SERVER_NAME:UNICODE") REPLICA_UNICODE=$VAL;;
        "$START_SERVER_NAME:BINARY") REPLICA_BINARY=$VAL;;
        "$START_SERVER_NAME:PULL_INTERVAL") PULL_INTERVAL=$VAL;;
        "$START_SERVER_NAME:LBR_REPLICATION") LBR_REPLICATION=$VAL;;
        "$START_SERVER_NAME:DB_REPLICATION") DB_REPLICATION=$VAL;;
      esac
    fi
  done < $CONFIG_FILE

  if [ $START_SERVER_TYPE != "server" ] && [ $START_SERVER_TYPE != "commit-server" ]; then
    while read line;
    do
      VAR=`echo $line | cut -d'=' -f1`
      VAL=`echo $line | cut -d'=' -f2`
      VAL=`echo $VAL | cut -d' ' -f1`
      case $VAR in
        "$REPLICA_MASTER_NAME:PORT") REPLICA_MASTER_PORT=$VAL;;
        "$REPLICA_MASTER_NAME:ROOT") REPLICA_MASTER_ROOT=$VAL;;
      esac
    done < $CONFIG_FILE
  fi

  if [ $START_SERVER_TYPE == "server" ] || [ $START_SERVER_TYPE == "commit-server" ]; then
    echo "Commit/Master: server settings"
    echo "$MASTER_NAME: Type: $MASTER_SERVER_TYPE"
    echo "$MASTER_NAME: Service User:  $SERVICE_USER"
    echo "$MASTER_NAME: Server Name: $MASTER_SERVER_NAME"
    echo "$MASTER_NAME: Port: $MASTER_PORT"
    echo "$MASTER_NAME: Root: $MASTER_ROOT"
    echo "$MASTER_NAME: Log: $MASTER_LOG"
    echo "$MASTER_NAME: Debug: $MASTER_DEBUG"
    echo "$MASTER_NAME: Monitor: $MASTER_MONITOR"
    echo "$MASTER_NAME: Unicode: $MASTER_UNICODE"
    echo "$MASTER_NAME: Binary: $MASTER_BINARY"
  else
    echo "Replica server settings"
    echo "$REPLICA_NAME: Master Port: $REPLICA_MASTER_PORT"
    echo "$REPLICA_NAME: Master Root: $REPLICA_MASTER_ROOT"
    echo "$REPLICA_NAME: Type: $REPLICA_SERVER_TYPE"
    echo "$REPLICA_NAME: Service User:  $SERVICE_USER"
    echo "$REPLICA_NAME: Server Name: $REPLICA_SERVER_NAME"
    echo "$REPLICA_NAME: Port: $REPLICA_PORT"
    echo "$REPLICA_NAME: Root: $REPLICA_ROOT"
    echo "$REPLICA_NAME: UNICODE:  $REPLICA_UNICODE"
    echo "$REPLICA_NAME: BINARY:  $REPLICA_BINARY"
    echo "$REPLICA_NAME: Log: $REPLICA_LOG"
    echo "$REPLICA_NAME: Debug: $REPLICA_DEBUG"
    echo "$REPLICA_NAME: Monitor: $REPLICA_MONITOR"
    echo "$REPLICA_NAME: Root: $REPLICA_ROOT"
    echo "$REPLICA_NAME: Pull Interval:  $PULL_INTERVAL"
    echo "$REPLICA_NAME: lbr:  $LBR_REPLICATION"
    echo "$REPLICA_NAME: db:  $DB_REPLICATION"

  fi

  read -p "Confirm settings? (y|n): " RESPONSE
  if [ "$RESPONSE" !=  "y" ]; then
    exit
  fi

  if [ $START_SERVER_TYPE == "server" ] || [ $START_SERVER_TYPE == "commit-server" ]; then
    SERVER_PORT=$MASTER_PORT
    SERVER_NAME=$MASTER_SERVER_NAME
    SERVER_ROOT=$MASTER_ROOT
    SERVER_BINARY=$MASTER_BINARY
  else
    SERVER_PORT=$REPLICA_PORT
    SERVER_NAME=$REPLICA_SERVER_NAME
    SERVER_ROOT=$REPLICA_ROOT
    SERVER_BINARY=$REPLICA_BINARY
  fi
}

function check_server {
  # Check to see if the server is already running.
  if [ "$RESTART" != "restart" ]; then
    OUT=`ps -ax | grep $SERVER_PORT | grep p4d`
    if [ $? -eq 0 ]; then
      echo "A server on port $SERVER_PORT is already running."
      read -p "Do you want to continue? (y|n): " RESPONSE
      if [ "$RESPONSE" !=  "y" ]; then
        exit
      fi
    fi
  fi
}

function stop_server {
  echo
  echo "Stopping $START_SERVER_NAME on $SERVER_PORT."
  echo
  
  # Stop the server.
  OUT=`ps -ax | grep $SERVER_PORT | grep p4d`
  if [ $? -eq 0 ]; then
    p4 -p $SERVER_PORT -u usuper admin stop
    sleep 2
    if [ $? -ne 0 ]; then
      echo "Problem stopping server running on $SERVER_PORT."
      echo "Stop the server manually, then re-run script."
      exit
    fi
  fi
  OUT=`ps -ax | grep $SERVER_PORT | grep p4d`
  if [ $? -eq 0 ]; then
    echo "Problem stopping server running on $SERVER_PORT."
    echo "Stop the server manually, then re-run script."
    exit
  fi
}

function start_server {
  echo
  echo "Starting $START_SERVER_NAME on $SERVER_PORT."
  echo
  # Start the server.
  $SERVER_BINARY -p $SERVER_PORT -r $SERVER_ROOT &
  sleep 2
  p4 -p $SERVER_PORT -u usuper info
  exit
}

function create_server_root {
  # Create new server root directories.
  rm -rf $SERVER_ROOT
  mkdir -p $SERVER_ROOT
}

function setup_master {
  # Set up master/commit servers.
  echo
  echo "---- Start master setup ---"
  if [ $MASTER_UNICODE == "1" ]; then
    $SERVER_BINARY -p $MASTER_PORT -r $MASTER_ROOT -xi
    sleep 2
  fi
  $SERVER_BINARY -p $MASTER_PORT -r $MASTER_ROOT -vserver=$MASTER_DEBUG -L $MASTER_LOG &
  sleep 2

  # Create the server serverid.
  p4 -p $MASTER_PORT -u usuper serverid $MASTER_SERVER_NAME

  # Create a server spec for the server.
  echo "
ServerID: $MASTER_SERVER_NAME
Type: server
Name: $MASTER_SERVER_NAME
Address: $MASTER_PORT 
Services: $MASTER_SERVER_TYPE
Description: $MASTER_SERVER_TYPE
  " | p4 -p $MASTER_PORT -u usuper server -i

  # Create a service user.
  echo "
User: $SERVICE_USER
Type: service
Email: $SERVICE_USER
Fullname: $SERVICE_USER
  " | p4 -p $MASTER_PORT -u usuper user -f -i

  # Create a group for the service user.
  echo "
Group: service_users
Timeout: unlimited
PasswordTimeout: unlimited
Subgroups:
Owners:
Users:
 $SERVICE_USER
  " | p4 -p $MASTER_PORT -u usuper group -i

  # Create a protections for the service user.
  echo "

Protections:
	write user * * //...
	super user usuper * //...
	super user $P4USER * //...
	super user $SERVICE_USER * //...
  " | p4 -p $MASTER_PORT -u usuper protect -i

  p4 -p $MASTER_PORT -u usuper user -f -o $P4USER | p4 -p $MASTER_PORT -u usuper user -f -i

  # Set configurables for the server.
  p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#monitor=$MASTER_MONITOR"
  p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#server=$MASTER_DEBUG"
  p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#P4LOG=$MASTER_LOG"
  p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#serviceUser=$SERVICE_USER"
  #p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#rpl=4"
  #p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#time=1"
  #p4 -p $MASTER_PORT -u usuper configure set "$MASTER_SERVER_NAME#lbr=3"

  echo
  echo "---- End setup ---"

  p4 -p $MASTER_PORT -u usuper -ztag info

}

# Set up edge/replica servers.
function setup_replica {
  echo "---- Start replica setup ---"
  # Create a server spec for the edge/replica server.
  echo "
ServerID: $REPLICA_SERVER_NAME
Type: server
Name: $REPLICA_SERVER_NAME
Address: $REPLICA_PORT
Services: $REPLICA_SERVER_TYPE
Description: $REPLICA_SERVER_TYPE
" | p4 -p $REPLICA_MASTER_PORT -u usuper server -i

  # Set configurables on the edge/replica server.
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#P4TARGET=$REPLICA_MASTER_PORT"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#monitor=$REPLICA_MONITOR"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#server=$REPLICA_DEBUG"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#rpl=4"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#time=1"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#lbr=3"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#P4LOG=$REPLICA_LOG"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#startup.1=pull -i $PULL_INTERVAL"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#startup.2=pull -u -i $PULL_INTERVAL"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#startup.3=pull -u -i $PULL_INTERVAL"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#db.replication=$DB_REPLICATION"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#lbr.replication=$LBR_REPLICATION"
  p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#serviceUser=$SERVICE_USER"
  if [ $REPLICA_SERVER_TYPE == "forwarding-replica" ] || [ $REPLICA_SERVER_TYPE == "edge-server" ]; then
    p4 -p $REPLICA_MASTER_PORT -u usuper configure set "$REPLICA_SERVER_NAME#rpl.forward.all=1"
  fi

  # Checkpoint the edge/replica server.
  p4 -p $REPLICA_MASTER_PORT -u usuper admin checkpoint
  sleep 2
  CKP=`p4 -p $REPLICA_MASTER_PORT -u usuper counter journal`

  if [ $REPLICA_UNICODE == "1" ]; then
    $SERVER_BINARY -r $REPLICA_ROOT -xi
    sleep 2
  fi

  # Restore the commit/master server checkpoint on the edge/replica server.
  $SERVER_BINARY -r $REPLICA_ROOT -jr $REPLICA_MASTER_ROOT/checkpoint.$CKP
  sleep 2

  # Start the edge server.
  $SERVER_BINARY -p $REPLICA_PORT -In $REPLICA_SERVER_NAME -r $REPLICA_ROOT &
  sleep 2

  # Create a ServerID for the edge server.
  p4 -p $REPLICA_PORT -u usuper serverid $REPLICA_SERVER_NAME

  # Restart the replica so the pull threads get the right config
  p4 -p $REPLICA_PORT -u usuper admin restart

  echo
  echo "---- End setup ---"
  p4 -p $REPLICA_PORT -u usuper -ztag info

}

CONFIG_FILE=$1
START_SERVER_NAME=$2
ACTION=$3

case $1 in 
  "-C") 
    make_config
    ;;
esac

case $3 in
  "restart")
    read_config $CONFIG_FILE $START_SERVER_NAME
    stop_server
    start_server
    ;;
  "setup")
    read_config $CONFIG_FILE $START_SERVER_NAME
    check_server
    stop_server
    create_server_root
    if [ $START_SERVER_TYPE == "server" ] || [ $START_SERVER_TYPE == "commit-server" ]; then
      setup_master
    else
      setup_replica
    fi
    ;;
  *) 
    usage
    ;;
esac
exit

