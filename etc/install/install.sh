#!/bin/bash

PROJECT_NAME=$1

DB_NAME=$PROJECT_NAME
VIRTUALENV_NAME=$PROJECT_NAME

PROJECT_DIR=/home/vagrant/$PROJECT_NAME
VIRTUALENV_DIR=/home/vagrant/.virtualenvs/$PROJECT_NAME
LOCAL_SETTINGS_PATH="/$PROJECT_NAME/settings/local.py"

# Install essential packages from Apt
apt-get update -y
# Python dev packages
apt-get install -y build-essential
# Git (we'd rather avoid people keeping credentials for git commits in the repo, but sometimes we need it for pip requirements that aren't in PyPI)
apt-get install -y git

# Postgresql
if ! command -v psql; then
    apt-get install -y postgresql libpq-dev
    # Create vagrant pgsql superuser
    su - postgres -c "createuser -s vagrant"
fi

apt-get install python3-pip -y

if [[ ! -f /usr/local/bin/virtualenv ]]; then
    pip3 install virtualenv virtualenvwrapper stevedore virtualenv-clone
fi

# bash environment global setup
cp -p $PROJECT_DIR/etc/install/bashrc /home/vagrant/.bashrc

# ---

# postgresql setup for project
su - vagrant -c "createdb $DB_NAME"

# virtualenv setup for project
su - vagrant -c "/usr/local/bin/virtualenv $VIRTUALENV_DIR --python=/usr/bin/python3 && \
    echo $PROJECT_DIR > $VIRTUALENV_DIR/.project && \
    $VIRTUALENV_DIR/bin/pip install -r $PROJECT_DIR/requirements.txt"

echo "workon $VIRTUALENV_NAME" >> /home/vagrant/.bashrc

# Django project setup
su - vagrant -c "source $VIRTUALENV_DIR/bin/activate"

# Add settings/local.py to gitignore
if ! grep -Fqx $LOCAL_SETTINGS_PATH $PROJECT_DIR/.gitignore
then
    echo $LOCAL_SETTINGS_PATH >> $PROJECT_DIR/.gitignore
fi
