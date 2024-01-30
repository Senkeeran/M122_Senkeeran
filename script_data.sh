#!/bin/bash

#Autor: Senkeeran Paranthaman
#Datum: 30.1.2024
#Version: 1.3
#Beschreibung:
"Dieses Skript liesst die Log Dateien, die im gleichem Verzeichnis abgespeichert.
In diesen Log Dateien werden die Daten von den Sensoren vom Server gespeichert.
Das Skript hat für jede Log Datei einen eigenen Schwellenwert, falls dieser Schwellenwert
überschritten wird, wird per E-Mail eine Nachricht verschickt."

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
  local benachrichtigung_satz=$3

# Überprüfe, ob die Datei existiert
  if [ -e "$datei" ]; then
    # Extrahiere den Wert aus der Datei
    wert=$(awk '{print $2}' "$datei")

    # Überprüfe, ob der Wert zu hoch ist
    if [ "$wert" -gt "$schwellenwert" ]; then
      nachricht="In Datei $datei ist der Wert zu hoch: $wert (Schwellenwert: $benachrichtigung_satz)"
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
  fi
}

# Dateien, Schwellenwerte und Benachrichtigungssätze
check_and_notify "/home/pi/logs/data_hum.txt" 50 "Warnung: Wert in Datei 1 ist zu hoch!"
check_and_notify "/home/pi/logs/data_light.txt" 30 "Achtung: Wert in Datei 2 überschreitet die Grenze!"
check_and_notify "/home/pi/logs/data_sound.txt" 300  "Hinweis: Der Wert in Datei 3 ist erhöht."
check_and_notify "home/pi/logs/data_temp.txt" 20 "Meldung: Wert in Datei 4 sollte überprüft werden."
