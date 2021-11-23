interface="wlp61s0"

getNetworkId() {
  id=`wpa_cli -i $interface list_networks | grep $ssid | awk '{print $1}'`
  echo $id
}

setSecretForSsid() {
  getNetworkId
  wpa_cli -i $interface $secretName $id $secret
}

while IFS="," read -r ssid secretName secret
do
  setSecretForSsid $ssid $secretName $secret
done < /home/mschwaig/.wifi-passwords.csv

wpa_cli -i $interface scan
