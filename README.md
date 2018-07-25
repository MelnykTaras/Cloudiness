Cloudiness
=========

## Installation

1. To fix linker error `bitcode bundle could not be generated ...` add user-defined setting to Pods project:
Pods project -> Build Settings -> press plus button: "Add a new conditional or user-defined build setting" -> Add User-Defined Setting -> Enter setting title: `BITCODE_GENERATION_MODE` -> Enter setting value: `bitcode`
This setting is required to build Pods as static libraries instead of dynamic frameworks. Why static? Because static libraries are nearly 20% faster.

2. (Optional) Delete `-dummy.m` files from Pods project. [They should not be needed for pods which built from source.](https://github.com/CocoaPods/CocoaPods/issues/1767#issuecomment-42665300)

## Acknowledgements

Cloudiness forecast is based on data from [The Norwegian Meteorological Institute](https://www.met.no/en)
