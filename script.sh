

# FTP-Verbindungsinformationen
ftp_server="172.16.17.160"
benutzername="IoT-Log"
passwort="THLS-60s"
ftp_verzeichnis="/"

# Lokales Verzeichnis zum Speichern der heruntergeladenen Log-Dateien
lokales_verzeichnis="/home/pi/logs"

# E-Mail Konfiguration
empfaenger_email="senkeeran.paranthaman@edu.tbz.ch"
betreff="Neuester Log-Eintrag"
mailer="/etc/ssmtp/"

# FTP-Befehl zum Herunterladen der Log-Dateien
lftp -u $benutzername,$passwort $ftp_server -e "mirror --only-newer --verbose $ftp_verzeichnis $lokales_verzeichnis; quit"

# Optional: Überprüfen, data_tempdata_tempdata_tempob der Download erfolgreich war
if [ $? -eq 0 ]; then
  echo "Log-Dateien erfolgreich heruntergeladen."

  # Extrahiere den neuesten Wert
  neuester_wert=$(tail -n 1 $lokales_verzeichnis/neuester_log_eintrag.txt)

  # Sende E-Mail mit dem neuesten Wert
  echo -e "Subject:$betreff\n\nNeuester Log-Eintrag:\n$neuester_wert" | $mailer $empfaenger_email

  # Optional: Überprüfen, ob die E-Mail erfolgreich versendet wurde
  if [ $? -eq 0 ]; then
    echo "E-Mail erfolgreich versendet."
  else
    echo "Fehler beim Versenden der E-Mail."
    echo "Fehler beim Versenden der E-Mail."
  fi
else
  echo "Fehler beim Herunterladen der Log-Dateien."
fi