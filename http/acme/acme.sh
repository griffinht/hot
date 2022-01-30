#!/bin/bash

acme.sh \
  --cert-home /certificates \
  --config-home /acme \
  --server letsencrypt \
  --issue \
  -d 'griffinht.com' --dns dns_cf \
  -d '*.griffinht.com' --dns dns_cf \
  -d 'stzups.net' --dns dns_cf \
  -d 'griffin.ht' --dns dns_aws