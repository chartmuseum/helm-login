# helm login plugin
<img align="right" src="https://github.com/helm/chartmuseum/raw/master/logo.png">

[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/codefresh-inc/chartmuseum%2Fhelm-login%2Fhelm-login?branch=master&type=cf-2)]( https://g.codefresh.io/repositories/chartmuseum/helm-login/builds?filter=trigger:build;branch:master;service:5ad4eed637adc30001207fab~helm-login)

Helm plugin to authenticate against [ChartMuseum](https://github.com/helm/chartmuseum)

## Install
Based on the version in `plugin.yaml`, release binary will be downloaded from GitHub:

```
$ helm plugin install https://github.com/chartmuseum/helm-login
Downloading and installing helm-login v0.1.0 ...
https://github.com/chartmuseum/helm-login/releases/download/v0.1.0/helm-login_0.1.0_darwin_amd64.tar.gz
Installed plugin: login
```
