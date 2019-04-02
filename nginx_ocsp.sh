#!/bin/bash

gets() {
  if [ ! -z "$2" ]; then
    port=$2
  else
    port=443
  fi
  echo QUIT | openssl s_client -connect 127.0.0.1:${2} -servername ${1} -tls1_2 -cipher ECDH -status > /dev/null 2>&1
  echo QUIT | openssl s_client -connect 127.0.0.1:${2} -servername ${1} -tls1_2 -cipher aRSA:RSA -status > /dev/null 2>&1
}

file=`find /etc/nginx -name "*.conf"`

for names in $file; do
  # csplit source : https://stackoverflow.com/questions/9634953/how-to-split-a-nginx-virtual-host-config-file-into-small-ones-using-shell/38635284
  rm /tmp/ngx_ocsp*.tmp > /dev/null 2>&1
  csplit -z -f /tmp/ngx_ocsp -b %d.tmp $names '/^\s*server\s*{*$/' {*} > /dev/null 2>&1

  for i in /tmp/ngx_ocsp*.tmp; do
    result=`grep -oP '(?<=server_name ).+(?=;)' $i`
    if [ ! -z "$result" ]; then
      port=`grep -oP '(?<=listen ).+(?=ssl).+(?=;)' $i`
      new_name=`echo $result|awk '{print $1}'`
      new_name=${new_name%';'}
      port=`echo $port|sed 's/[^0-9]/ /g'|awk '{print $1}'`
      port=${port%';'}
      if [ ! -z "$port" ]; then
        hosts=(${hosts[@]} $new_name:$port)
      fi
    fi
  done
done

rm /rmp/ocsp*.tmp > /dev/null 2>&1

FINALS=`echo ${hosts[@]} | tr " " "\n" | sed -e "s/^*//g" | sed -e "s/*/wildcards/g" | sort -u`

for conn in $FINALS; do
  data1=`echo $conn | awk -F: '{print $1}'`
  data2=`echo $conn | awk -F: '{print $2}'`
  echo OCSP : $data1 - $data2
  gets $data1 $data2
done
