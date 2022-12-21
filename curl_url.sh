#URL="https://www.gitignore.io/api/nonexistentlanguage"

#response=$(curl -s -w "%{http_code}" $URL)
#response=$(curl -I $URL)

#http_code=$(tail -n1 <<< "$response")  # get the last line
#content=$(head -1 file1.c | rev | cut -d" " -f 1 | rev <<< "$response")   # get all but the last line which contains the status code
#content=$(head -1 response | rev| cut -d" " -f 1 | rev <<< "$response")

#echo "$http_code"
#echo "$content"
#echo "$response"




#read -p "Enter file name : " filename
#while read line
#do 
#echo $line
#done < $filename

#URL="https://www.uniqlo.com/jp/iq/"

#while true

#!/bin/bash
read -p "Enter file name : " filename
while read line
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' $line -m 5)
  if [ $STATUS -eq 200 ]; then
    echo "$line $STATUS OK"
    continue
  elif [ $STATUS -eq 201 ]; then
    echo "$line $STATUS Created"
    continue
  elif [ $STATUS -eq 202 ]; then
    echo "$line $STATUS Accepted"
    continue
  elif [ $STATUS -eq 203 ]; then
    echo "$line $STATUS Non-Authoritative Information"
    continue
  elif [ $STATUS -eq 204 ]; then
    echo "$line $STATUS No Content"
    continue
  elif [ $STATUS -eq 205 ]; then
    echo "$line $STATUS Reset Content"
    continue
  elif [ $STATUS -eq 206 ]; then
    echo "$line $STATUS Partial Content"
    continue
  elif [ $STATUS -eq 300 ]; then
    echo "$line $STATUS Multiple Choices"
    continue
  elif [ $STATUS -eq 301 ]; then
    echo "$line $STATUS Moved Permanently"
    continue
  elif [ $STATUS -eq 302 ]; then
    echo "$line $STATUS Found"
    continue
  elif [ $STATUS -eq 303 ]; then
    echo "$line $STATUS See Other"
    continue
  elif [ $STATUS -eq 304 ]; then
    echo "$line $STATUS Not Modified"
    continue
  elif [ $STATUS -eq 307 ]; then
    echo "$line $STATUS Temporary Redirect"
    continue
  elif [ $STATUS -eq 308 ]; then
    echo "$line $STATUS Permanent Redirect"
    continue
  elif [ $STATUS -eq 301 ]; then
    echo "$line $STATUS Moved Permanently"
    continue
  elif [ $STATUS -eq 302 ]; then
    echo "$line $STATUS FOUND"
    continue
  elif [ $STATUS -eq 403 ]; then
    echo "$line $STATUS Forbidden"
    continue
  else
    echo "$line TIMED OUT - Enter a valid url or not able to fetch the status"
    continue
  fi
done < $filename




#!/bin/bash
read -p "Enter file name : " filename
while read line
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' $line -m 5)
  case $STATUS in 
     100) echo "$line $STATUS Continue"
     ;;
     101) echo "$line $STATUS Switching Protocols"
     ;;
     103) echo "$line $STATUS Early Hints"
     ;;
     200) echo "$line $STATUS OK"
     ;;
     201) echo "$line $STATUS Created"
     ;;
     202) echo "$line $STATUS Accepted"
     ;;
     203) echo "$line $STATUS Non-Authoritative Information"
     ;;
     204) echo "$line $STATUS No Content"
     ;;
     206) echo "$line $STATUS Partial Content"
     ;;
     300) echo "$line $STATUS Multiple Choices"
     ;;
     301) echo "$line $STATUS Moved Permanently"
     ;;
     302) echo "$line $STATUS Found"
     ;;
     303) echo "$line $STATUS See Other"
     ;;
     304) echo "$line $STATUS Not Modified"
     ;;
     307) echo "$line $STATUS Temporary Redirect"
     ;;
     308) echo "$line $STATUS Permanent Redirect"
     ;;
     400) echo "$line $STATUS Bad Request"
     ;;
     401) echo "$line $STATUS Unauthorized"
     ;;
     402) echo "$line $STATUS Payment Required"
     ;;
     403) echo "$line $STATUS Forbidden"
     ;;
     404) echo "$line $STATUS Not Found"
     ;;
     405) echo "$line $STATUS Method Not Allowed"
     ;;
     406) echo "$line $STATUS Not Acceptable"
     ;;
     407) echo "$line $STATUS Proxy Authentication Required"
     ;;
     408) echo "$line $STATUS Request Timeout"
     ;;
     409) echo "$line $STATUS Conflict"
     ;;
     410) echo "$line $STATUS Gone"
     ;;
     411) echo "$line $STATUS Length Required"
     ;;
     412) echo "$line $STATUS Precondition Failed"
     ;;
     413) echo "$line $STATUS Payload Too Large"
     ;;
     414) echo "$line $STATUS URI Too Long"
     ;;
     415) echo "$line $STATUS Unsupported Media Type"
     ;;
     416) echo "$line $STATUS Range Not Satisfiable"
     ;;
     417) echo "$line $STATUS Expectation Failed"
     ;;
     418) echo "$line $STATUS I'm a teapot"
     ;;
     422) echo "$line $STATUS Unprocessable Entity"
     ;;
     425) echo "$line $STATUS Too Early"
     ;;
     426) echo "$line $STATUS Upgrade Required"
     ;;
     428) echo "$line $STATUS Precondition Required"
     ;;
     429) echo "$line $STATUS Too Many Requests"
     ;;
     431) echo "$line $STATUS Request Header Fields Too Large"
     ;;
     451) echo "$line $STATUS Unavailable For Legal Reasons"
     ;;
     500) echo "$line $STATUS Internal Server Error"
     ;;
     501) echo "$line $STATUS Not Implemented"
     ;;
     502) echo "$line $STATUS Bad Gateway"
     ;;
     503) echo "$line $STATUS Service Unavailable"
     ;;file_name=$(awk -F ' ' '{print $5}' $filename)
     505) echo "$line $STATUS HTTP Version Not Supported"
     ;;
     506) echo "$line $STATUS Variant Also Negotiates"
     ;;
     507) echo "$line $STATUS Insufficient Storage"
     ;;
     508) echo "$line $STATUS Loop Detected"
     ;;
     510) echo "$line $STATUS Not Extended"
     ;;
     511) echo "$line $STATUS Network Authentication Required"
     ;;
     *) echo "$line $STATUS TIMEOUT - Incorrect URL or not able to fetch the status"
     esac
done < $filename
