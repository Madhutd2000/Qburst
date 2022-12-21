#!/bin/bash
read -p "Enter file name : " filename
while IFS=" " read colA colB colC colD line colE colF
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' $line -m 10)
  case $STATUS in 
     100) echo "$colD $line $STATUS Continue"
     ;;
     101) echo "$colD $line $STATUS Switching Protocols"
     ;;
     103) echo "$colD $line $STATUS Early Hints"
     ;;
     200) echo "$colD $line $STATUS OK"
     ;;
     201) echo "$colD $line $STATUS Created"
     ;;
     202) echo "$colD $line $STATUS Accepted"
     ;;
     203) echo "$colD $line $STATUS Non-Authoritative Information"
     ;;
     204) echo "$colD $line $STATUS No Content"
     ;;
     206) echo "$colD $line $STATUS Partial Content"
     ;;
     300) echo "$colD $line $STATUS Multiple Choices"
     ;;
     301) echo "$colD $line $STATUS Moved Permanently"
     ;;
     302) echo "$colD $line $STATUS Found"
     ;;
     303) echo "$colD $line $STATUS See Other"
     ;;
     304) echo "$colD $line $STATUS Not Modified"
     ;;
     307) echo "$colD $line $STATUS Temporary Redirect"
     ;;
     308) echo "$colD $line $STATUS Permanent Redirect"
     ;;
     400) echo "$colD $line $STATUS Bad Request"
     ;;
     401) echo "$colD $line $STATUS Unauthorized"
     ;;
     402) echo "$colD $line $STATUS Payment Required"
     ;;
     403) echo "$colD $line $STATUS Forbidden"
     ;;
     404) echo "$colD $line $STATUS Not Found"
     ;;
     405) echo "$colD $line $STATUS Method Not Allowed"
     ;;
     406) echo "$colD $line $STATUS Not Acceptable"
     ;;
     407) echo "$colD $line $STATUS Proxy Authentication Required"
     ;;
     408) echo "$colD $line $STATUS Request Timeout"
     ;;
     409) echo "$colD $line $STATUS Conflict"
     ;;
     410) echo "$colD $line $STATUS Gone"
     ;;
     411) echo "$colD $line $STATUS Length Required"
     ;;
     412) echo "$colD $line $STATUS Precondition Failed"
     ;;
     413) echo "$colD $line $STATUS Payload Too Large"
     ;;
     414) echo "$colD $line $STATUS URI Too Long"
     ;;
     415) echo "$colD $line $STATUS Unsupported Media Type"
     ;;
     416) echo "$colD $line $STATUS Range Not Satisfiable"
     ;;
     417) echo "$colD $line $STATUS Expectation Failed"
     ;;
     418) echo "$colD $line $STATUS I'm a teapot"
     ;;
     422) echo "$colD $line $STATUS Unprocessable Entity"
     ;;
     425) echo "$colD $line $STATUS Too Early"
     ;;
     426) echo "$colD $line $STATUS Upgrade Required"
     ;;
     428) echo "$colD $line $STATUS Precondition Required"
     ;;
     429) echo "$colD $line $STATUS Too Many Requests"
     ;;
     431) echo "$colD $line $STATUS Request Header Fields Too Large"
     ;;
     451) echo "$colD $line $STATUS Unavailable For Legal Reasons"
     ;;
     500) echo "$colD $line $STATUS Internal Server Error"
     ;;
     501) echo "$colD $line $STATUS Not Implemented"
     ;;
     502) echo "$colD $line $STATUS Bad Gateway"
     ;;
     503) echo "$colD $line $STATUS Service Unavailable"
     ;;
     504) echo "$colD $line $STATUS Gateway Timeout"
     ;;
     505) echo "$colD $line $STATUS HTTP Version Not Supported"
     ;;
     506) echo "$colD $line $STATUS Variant Also Negotiates"
     ;;
     507) echo "$colD $line $STATUS Insufficient Storage"
     ;;
     508) echo "$colD $line $STATUS Loop Detected"
     ;;
     510) echo "$colD $line $STATUS Not Extended"
     ;;
     511) echo "$colD $line $STATUS Network Authentication Required"
     ;;
     *) echo "$colD $line $STATUS TIMEOUT - Incorrect URL or not able to fetch the status"
     esac
done < $filename
