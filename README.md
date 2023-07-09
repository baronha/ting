![Logo][Logo]

<p align="center">
  <img src="./resources/Ting.png" width="100%">
</p>

[![Swift][Swift]][Swift-URL] [![Kotlin][Kotlin]][Kotlin-URL] [![React-Native][React-Native]][React-Native-URL] 

## Installation

```sh
yarn add @baronha/ting
or
npm i @baronha/ting
```

### [![iOS][iOS]][iOS-URL]
#### New Architecture
```sh
cd ios && RCT_NEW_ARCH_ENABLED=1 bundle exec pod install --verbose
```
#### Older
```sh
cd ios && pod install --verbose
```

### [![Android][Android]][Android-URL]

## Usage

### ![Toast][Toast]

```js
import { toast } from 'ting';
// ...
const options = {
    title: 'Done 😎',
    message: 'Successful!!',
}
toast(options)
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

<!-- Badge for README -->
[iOS]: https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white
[iOS-URL]: https://www.apple.com/ios

[Android]: https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white
[Android-URL]: https://www.android.com/

[React-Native]: https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-Native-URL]: https://reactnative.dev/

[React-Native]: https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-Native-URL]: https://reactnative.dev/

[Swift]: https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white
[Swift-URL]: https://developer.apple.com/swift/

[Kotlin]: https://img.shields.io/badge/Kotlin-0095D5?&style=for-the-badge&logo=kotlin&logoColor=white
[Kotlin-URL]: https://kotlinlang.org/

[Logo]: https://img.shields.io/badge/🍞_Ting-FDC753?style=for-the-badge

[Toast]: https://img.shields.io/badge/🍞_Toast-FDC753?style=for-the-badge