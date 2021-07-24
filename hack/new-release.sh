#!/usr/bin/env bash
# Ugly quick and dirty hack to make new release more easy
# Require yq and coreutils

: "${1?"Usage: $0 You need to specifiy a version"}"

RELEASE="$1"
URL="https://storage.googleapis.com/tekton-releases/pipeline/previous/${RELEASE}/release.yaml"

curl -s -L -O "$URL" > /dev/null

csplit --prefix=tk-operator release.yaml \
		--elide-empty-files \
		--quiet \
		--suffix-format='%02d.yaml' \
		"/---/+1" '{*}'

for file in tk-operator*; do
		kind=$(yq -M -r '.kind // empty' "$file"|tr '[:upper:]' '[:lower:]')
		name=$(yq -M -r '.metadata.name // empty' "$file")
		mv "$file" "$kind-$name.yaml"
done

rm release.yaml
rm kustomization.yaml 

kustomize create --autodetect

