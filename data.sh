#!/usr/bin/env bash

mkdir -p dataset

for y in 2021 2022 2023 2024;do
    o=dataset/dvf-${y}.csv.gz
    if [ ! -f "$o" ];then
        wget -c https://files.data.gouv.fr/geo-dvf/latest/csv/$y/full.csv.gz -O "$o"
    fi
done

# Note: DPE après 2021
if [ ! -f dataset/dpe-logements-existants.csv ];then
    rm -f header
    url='https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-existants/lines?size=10000&page=1&format=csv'
    while [ -n "$url" ];do
        curl -s "$url" -D header >> dataset/dpe-logements-existants.csv
        url="$(sed -nE 's/link: <([^>]+).*/\1/p' < header)"
    done
fi

# Other databases available:
# DPE avant 2021
# DPE logements neufs après 2021
# DPE tertiaire
