*Read this in other languages: [English](CHANGELOG.en-us.md), [简体中文](CHANGELOG.md).*

# v2.0.4(2019-6-9)
## Fixes
- fix error `12903` when returning to foreground from background.
- support background audio streaming.

# v2.0.3(2019-5-7)
## Fixes
- fix main thread been block after `-startCapturingWithCompletion` being called.

# v2.0.2(2019-5-5)
## Fixes
- fix `preferredVideoOrientation` becomes invalid after switching camera.

# v2.0.1(2019-4-29)
## Features
- add `flashMode` to adjust flash mode.
## Others
- update header documentations.
- update MovieousBase to v1.0.5.

# v2.0.0(2019-4-23)
## Feature
- support more camera operations(auto focus and exposure mode, etc.).
- support embedded face beauty and watermark.
## Enhancement
- use new kernel, reduce more than 50% of memory and CPU usage.
- improve stablity.
## Others
- interface on v2.x.x is not compatible with v1.x.x, you need to update relevant code if you update to this version.

# v1.0.2(2018-12-8)
## Feature
- add pause and resume interface for embedded capture.

# v1.0.1(2018-12-6)
## Fixes
- fix problem that external video processing is not effective for preview.

# v1.0.0(2018-11-28)
- initial release.