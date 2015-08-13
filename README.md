# XNGPodSynchronizer

[![Build Status](https://travis-ci.org/xing/XNGPodsSynchronizer.svg?branch=master)](https://travis-ci.org/xing/XNGPodSynchronizer)
[![Coverage Status](https://coveralls.io/repos/xing/XNGPodsSynchronizer/badge.svg?branch=master)](https://coveralls.io/r/xing/XNGPodSynchronizer?branch=master)

XNGPodSynchronizer reads `Podfile.locks` of your projects, copies the `.podspec`s from the CocoaPods master repository and mirrors it to your own `git` repository (e.g. GitHub Enterprise). This helps you get independent from `github.com`.

## Installation

XNGPodSynchronizer is distributed as a Ruby gem and can be installed using the following command:

```bash
$ gem install pod-synchronize
```

## Usage

XNGPodSynchronizer takes a `config.yml` as an argument an example `Yaml` would look like this:

```yaml
# config.yml
---
master_repo: https://github.com/CocoaPods/Specs.git
mirror:
  specs_push_url: git@git.hooli.xyz:pods-mirror/Specs.git
  source_push_url: git@git.hooli.xyz:pods-mirror
  source_clone_url: git://git.hooli.xyz/pods-mirror
  github:
    acccess_token: 0y83t1ihosjklgnuioa
    organisation: pods-mirror
    endpoint: https://git.hooli.xyz/api/v3
podfiles:
  - "https://git.hooli.xyz/ios/moonshot/raw/master/Podfile.lock"
  - "https://git.hooli.xyz/ios/nucleus/raw/master/Podfile.lock"
  - "https://git.hooli.xyz/ios/bro2bro/raw/master/Podfile.lock"
pods:
  - Google-Mobile-Ads-SDK
```

|key|meaning|
|:----|:----|
|master_repo|CocoaPods master repository (usually: https://github.com/CocoaPods/Specs.git)|
|mirror.specs_push_url|Git URL used to clone & push the mirrored specs|
|mirror.source_push_url|Git URL used to push the mirrored repositories|
|mirror.source_clone_url|Git URL used to change the download URLs in the podspecs|
|mirror.github.access_token|Access token used to create new repositories|
|mirror.github.organisation|The GitHub organization used for mirrored repositories|
|mirror.github.endpoint|API Endpoint of your GitHub api|
|podfiles|List of __Podfile.lock__ in __Plain Text__ format|
|pods|List of additional Pods you would like to add|

We use Jenkins to run the synchronize process twice daily. To do that use the following command:

```
$ pod-synchronize synchronize config.yml
```

## TODO

* Support Gitlab [#1](https://github.com/xing/XNGPodSynchronizer/issue/1)

## Contributing

1. Fork it ( https://github.com/xing/XNGPodSynchronizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Authors

[Matthias Männich](https://github.com/matthias-maennich) and [Piet Brauer](https://github.com/pietbrauer)

Copyright (c) 2015 [XING AG](https://xing.com/)

Released under the MIT license. For full details see LICENSE included in this distribution.
