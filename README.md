EKS CA Thumbprint obtainer
====

This script automates the acquisition of CA thumbprint.  
For example, it can be used to configure EKS nodes that support IAM Role for each pod.

## Description

This command automates the following operations:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html

## Usage

```
usage: ca_thumbprint.sh <OIDC IdP's URL>
OIDC IdP's URL is like this: oidc.eks.ap-northeast-1.amazonaws.com/id/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## Licence

MIT

## Author

[Kazylla](https://github.com/Kazylla)
