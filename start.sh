#!/bin/bash

set -x

REPO_PATH=/srv/repo.git

first_start=false

# Run ssh server
/etc/init.d/ssh start

# Create and configure a git bare repository if do not exists
if [[ ! -d "$REPO_PATH" ]]; then
  first_start=true

  # Create
  mkdir $REPO_PATH
  cd $REPO_PATH
  git --bare init

  # Add a hook on push to kill the node server
  cat <<EOF>>$REPO_PATH/hooks/post-receive
#!/bin/bash

echo "killing node server..."
pkill -15 node
EOF

  chmod +x $REPO_PATH/hooks/post-receive
fi

# Create ssh keys directory
if [[ ! -d "/root/.ssh" ]]; then
  mkdir /root/.ssh
fi

# Add authorized keys
cat /srv/keys/* > /root/.ssh/authorized_keys 2> /dev/null

while true
do
  # Get the parse-cloud folder
  if [[ $first_start == false ]]; then
    cd $PARSE_HOME/parse-cloud
    rm -fr ./* ./.*
    git clone $REPO_PATH .
  fi

  # Start
  cd $PARSE_HOME
  npm start

  echo "restarting server"
  first_start=false
done
