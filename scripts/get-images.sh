#!/usr/bin/env bash

# get-images.sh :
# extract image urls from the beer dataset,
# download images to local dir ./beer-images.

set -e

extract_image_url() {
    # extract an image url, print it (else skip)
    local item="${1}"
    [[ $(echo "${item}" | grep -i '.png') ]] && \
	echo "${item}" | python3 <(cat <<EOF
import sys
print(sys.stdin.read().replace(",","").strip().replace('"', ""))
EOF
)
}

extract_all_image_urls() {
    # extract urls to ./beer-image-urls.txt
    for line in $(grep -e '.png' beer-database/*.json); do
	extract_image_url "${line}" | tee -a ./beer-image-urls.txt
    done
}

download_images() {
    # download all images to ./beer-images
    mkdir -p ./beer-images && \
	aria2c --continue -i./beer-image-urls.txt -j4 -d ./beer-images
}


echo -e "Run any of:"
echo -e "~~~~~~~~~~~"
echo -e " extract_image_url"
echo -e " extract_all_image_urls"
echo -e " download_images"
