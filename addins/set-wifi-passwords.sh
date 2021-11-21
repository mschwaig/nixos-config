# wpa_supplicant="/nix/store/76j9l4d6h5q2gi8qn6mg2x3k069dh5cw-wpa_supplicant-2.9"
interface="wlp61s0"

getNetworkId() {
  id=`${wpa_supplicant}/bin/wpa_cli -i $interface list_networks | grep $ssid | awk '{print $1}'`
  echo $id
}

setSecretForSsid() {
  getNetworkId
  ${wpa_supplicant}/bin/wpa_cli -i $interface $secretName $id $secret
}

while IFS="," read -r ssid secretName secret
do
  setSecretForSsid $ssid $secretName $secret
done < /home/mschwaig/.wifi-passwords.csv

${wpa_supplicant}/bin/wpa_cli -i $interface scan
