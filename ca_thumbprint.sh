#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2019 Kazylla
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# refer to:
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html

PROVIDER_URL=$1
if [ "$PROVIDER_URL" = "" ];then
  echo "usage: $0 <OIDC IdP's URL>"
  echo "OIDC IdP's URL is like this: oidc.eks.ap-northeast-1.amazonaws.com/id/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  exit 1
fi

# extract jwks_uri from configuration URL
JWKS_URI=`curl -s https://${PROVIDER_URL}/.well-known/openid-configuration | jq -r .jwks_uri`

# extract hostname from jwks_uri
JWKS_HOST=`echo "${JWKS_URI}" | sed 's|https://\([^/]*\)/.*|\1|g'`

# extract certificate of the root CA in the certificate authority chain
CERTS=`openssl s_client -servername ${JWKS_URI} -showcerts -connect ${JWKS_HOST}:443 << EOF 2>&1`
LINES=(`echo "${CERTS}" | grep -n "CERTIFICATE" | tail -n 2 | sed 's/^\([^:]*\):.*/\1/'`)
echo "${CERTS}" | sed -n ${LINES[0]},${LINES[1]}p > certificate.crt

# obtain the certificate thumbprint
openssl x509 -in certificate.crt -fingerprint -noout | awk '{print $2}' | sed 's/://g'
rm certificate.crt

