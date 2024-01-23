#!/bin/bash

# E-Mail Konfiguration
empfaenger_email="senkeeran.paranthaman@edu.tbz.ch"
betreff="Warnung: Wert zu hoch"
sender="senkeeran.paranthaman@smart-mail.de"


# Funktion zum Senden der E-Mail
send_email() {
  local nachricht=$1
  echo -e "$nachricht" | mail -s "$betreff" -a "From: $sender" "$empfaenger_email"
}

#Dateien und Schwellenwerte
datei1="/home/pi/logs/data_hum.txt"
schwellenwert1=50

datei2="/home/pi/logs/data_light.txt"
schwellenwert2=30

datei3="/home/pi/logs/data_sound.txt"
schwellenwert3=300

datei4="/home/pi/logs/data_temp.txt"
schwellenwert4=20

# Überprüfe Dateien und sende E-Mail bei Bedarf
check_and_notify() {
  local datei=$1
  local schwellenwert=$2

# Überprüfe, ob die Datei existiert
  if [ -e "$datei" ]; then
    # Extrahiere den Wert aus der Datei
    wert=$(awk '{print $2}' "$datei")

    # Überprüfe, ob der Wert zu hoch ist
    if [ "$wert" -gt "$schwellenwert" ]; then
      nachricht="In Datei $datei ist der Wert zu hoch: $wert (Schwellenwert: $schwellenwert)"
      send_email "$nachricht"
    fi
  else
    nachricht="Datei $datei existiert nicht."
    send_email "$nachricht"
  fi
    # Wenn der Wert höher
    if [ "$wert" -lt "$schwellenwert" ]; then
    nachricht="Der Wert ist nicht zu hoch"
    send_mail "$nachricht"
}

# Rufe die Funktion für jede Datei auf
check_and_notify "/home/pi/logs/data_hum.txt" 50
check_and_notify "/home/pi/logs/data_light.txt" 30
check_and_notify "/home/pi/logs/data_sound.txt" 300
check_and_notify "home/pi/logs/data_temp.txt" 20