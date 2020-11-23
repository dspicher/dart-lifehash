Dart lifehash
=============

[Lifehash](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-005-ur.md) is a
> method of hash visualization based on Conway’s Game of Life that creates beautiful icons that are deterministic, yet distinct and unique given the input data.


## Getting started
Until this package is published on pub.dev, include the following in your `pubspec.yaml`:
```yaml
dependencies:
  lifehash:
    git:
      url: git://github.com/dspicher/dart-lifehash.git
      ref: 0f5db7dfb91bd4e41267d7ad88a4abce1a578b32
```

## Examples
The `example/` folder contains the source for a mobile application showcasing lifehashes. It includes a reproduction of the [demo gallery](https://raw.githubusercontent.com/BlockchainCommons/LifeHash/master/Art/Samples-0.jpg) and a demonstration of the effect of flipping single bits in the input.

## Other implementations
This Dart implementation is based on the following reference implementations:
- [Mathematica](https://github.com/BlockchainCommons/LifeHash/tree/master/Mathematica)
- [Swift](https://github.com/BlockchainCommons/LifeHash/tree/master/Sources/LifeHash)

## Contributing
Pull requests are welcome.

## License
This project is licensed under the terms of the [MIT](https://choosealicense.com/licenses/mit/) license.
