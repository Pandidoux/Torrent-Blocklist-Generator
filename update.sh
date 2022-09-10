#!/usr/bin/env sh
# Reference from https://gist.github.com/johntyree/3331662#gistcomment-3215328

# Download and filter from iblocklist.com
echo "Download and filter from iblocklist.com"
curl -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0" -s https://www.iblocklist.com/lists.php \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| sed "s/\&amp;/\&/g" \
| sed "s/http/\"http/g" \
| sed "s/gz/gz\"/g" \
| xargs curl -s -L \
| gunzip \
| egrep -v '^#' \
| sed "/^$/d" > ./blocklists.p2p

# Download from mirror.codebucket.de
echo "Download from mirror.codebucket.de"
curl -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0" -s https://mirror.codebucket.de/transmission/blocklist.p2p >> ./blocklists.p2p

# Download from www.wael.name
echo "Download from www.wael.name"
curl -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0" -s https://www.wael.name/wael.list.txt | sed "/^#.*/d" | grep -Ev "^[0-9][0-9][0-9]\.[0-9][0-9][0-9].*" >> ./blocklists.p2p

# Remove duplicates
echo "Remove duplicates"
sort --unique ./blocklists.p2p > ./bt_deduplicated
mv ./bt_deduplicated ./blocklists.p2p

# Zip all files
echo "Zip all files"
gzip -c ./blocklists.p2p > ./blocklists.gz

echo "Ok"
