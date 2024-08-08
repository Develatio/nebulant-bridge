Nebulant Bridge
===============

![Nebulant](https://raw.githubusercontent.com/develatio/nebulant-bridge/main/logo.png)

This is part of [nebulant-cli][https://github.com/Develatio/nebulant-cli].

For more information, see the [website](https://nebulant.app) of the Nebulant.

<br />

📖 Documentation
--------------------------------------------------------------------------------

Find information about how to use the Bridge at
[our docs website](https://nebulant.app/docs/cli/).

<br />

🏁 Quick Start
--------------------------------------------------------------------------------

<br />

⚙️ Building locally
--------------------------------------------------------------------------------

If you want to compile the source code yourself, you can follow these steps:

Using Docker:

```shell
$ docker compose -f docker-compose.yml build --no-cache
$ docker compose -f docker-compose.yml run --rm buildenv all
```

This will build the source code for all supported OSs and architectures.

You can build the code for a specific combination of OS and architecture by
replacing `all` with the desired target in the second command. Example:

```shell
$ docker compose -f docker-compose.yml run --rm buildenv linux-amd64
```

Check the table of supported OSs and architectures.

<br />

🖥️ Supported OSs and architectures:
--------------------------------------------------------------------------------

|         | arm | arm64 | 386 | amd64 |
| ------- | --- | ----- | --- | ----- |
| linux   | ✅  |  ✅   | ✅  | ✅   |
| freebsd | ✅  |  ✅   | ✅  | ✅   |
| openbsd | ✅  |  ✅   | ✅  | ✅   |
| windows | ✅  |  ✅   | ✅  | ✅   |
| darwin  | N/A |  ✅   | N/A | ✅   |

<br />

🧰 Reproducible Build
--------------------------------------------------------------------------------

[Reproducible builds](https://reproducible-builds.org/) *are a set of software
development practices that create an independently-verifiable path from source
to binary code.*

At Develatio, we believe in transparency, and we emphasize the safety of our
products. For this reason, we offer you the means to build the source code
yourself and verify that the resulting binaries match the ones that we provide.

To reproduce ***nix** and **windows** builds follow these steps:

1. Clone the repo: `git clone https://github.com/Develatio/nebulant-bridge.git`
2. Checkout the version you'd like to build (e.g. `git checkout v0.6.0`)
3. Build the source code (check the `Building locally` section)
4. Run `diff` between the binary that you just built and the binary that we
provide. Make sure that both binaries have the same **version**, **OS** and
**architecture**. You should see no differences, meaning that the binary that
you downloaded contains the exact same code as the binary you just compiled.

To reproduce **darwin** (aka MacOS) builds, the first 3 steps are the same, but
before running the 4th step you need to perform an extra action.
The binaries that we provide are signed with our private certificate, while the
binaries that you can build from the source code aren't, which means that
`diff`ing the darwin binaries will yield differences. You must remove the
signature from the binary that we provide in order to be able to compare both
binaries.

Removing the signature is as easy as:

```shell
$ codesign --remove-signature nebulant-darwin-arm64
$ xxd nebulant-darwin-arm64 > unsigned-nebulant-darwin-arm64
```

Now you should be able to follow the 4th step and see no differences.

<br />

Nebulant Bridge Configuration
--------------------------------------------------------------------------------

<br />

🫡 Contributing
--------------------------------------------------------------------------------

If you find an issue, please report it to the
[issue tracker](https://github.com/develatio/nebulant-bridge/issues/new).

<br />

📑 License
--------------------------------------------------------------------------------

Copyright (c) Develatio Technologies S.L. All rights reserved.

Licensed under the [MIT](https://github.com/develatio/nebulant-bridge/blob/main/LICENSE) license.
