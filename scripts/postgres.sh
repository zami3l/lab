#!/bin/bash

######################################
# postgres.sh
# Description : Création BDD <msf> pour Metasploit
# Auteur: Zami3l
######################################

PATH_DB='/data/postgres'

mkdir -p $PATH_DB
chown postgres:postgres $PATH_DB
echo "Initialisation du cluster..."
sudo -iu postgres initdb --locale fr_FR.UTF-8 -D $PATH_DB

echo "Initialisation des fichiers de configuration..."
sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" $PATH_DB/postgresql.conf
echo  "shared_preload_libraries='pg_stat_statements'">> $PATH_DB/postgresql.conf
echo "unix_socket_directories='$PATH_DB'" >> $PATH_DB/postgresql.conf
echo "host    all    all    0.0.0.0/0    md5" >> $PATH_DB/pg_hba.conf

export PGHOST=$PATH_DB

echo "Démarrage du service"
sudo -iu postgres pg_ctl -D $PATH_DB start &
sleep 3s

echo "Création de l'utilisateur msf"
sudo -iu postgres createuser -h $PATH_DB -S -D -R -e msf

echo "Création de la base msf avec l'utilisateur msf"
sudo -iu postgres createdb -h $PATH_DB -O msf msf