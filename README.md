# Toolchain Version Constraints and Selection

Using [Toolchain resolution using configuration flags][proposal] which was
[introduced in Bazel 4.0.0][commit].

[proposal]: https://docs.google.com/document/d/13yXhOQeMZQmlW3obyZ7fJP3sm3eVLbK3Nuk2LZjcZiU/edit?usp=sharing
[commit]: https://github.com/bazelbuild/bazel/commit/780199d619bbec2a7dd695773cc3018d4de6c1e7

## Demo

### Build with a specific toolchain version

```shell
$ bazel build demo-all --toolchain_resolution_debug=//toolchains:toolchain_type --//toolchains:version=1.0.0
... Selected //toolchains:demo-x86_64-linux-x86_64-linux-1.0.0
... bazel-bin/demo-all.out
$ cat bazel-bin/demo-all.out
output:             bazel-out/k8-fastbuild/bin/demo-all.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   1.0.0
```

```shell
$ bazel build demo-all --toolchain_resolution_debug=//toolchains:toolchain_type --//toolchains:version=2.0.0
... Selected //toolchains:demo-x86_64-linux-x86_64-linux-2.0.0
... bazel-bin/demo-all.out
$ cat bazel-bin/demo-all.out
output:             bazel-out/k8-fastbuild/bin/demo-all.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   2.0.0
```

### Target compatibility with specific toolchain versions

```shell
$ bazel build demo-1 demo-2 --keep_going --show_result=2 --//toolchains:version=1.0.0
...
Target //:demo-2 was skipped
Target //:demo-1 up-to-date:
  bazel-bin/demo-1.out
$ cat bazel-bin/demo-1.out
output:             bazel-out/k8-fastbuild/bin/demo-1.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   1.0.0
```

```shell
$ bazel build demo-1 demo-2 --keep_going --show_result=2 --//toolchains:version=2.0.0
...
Target //:demo-1 was skipped
Target //:demo-2 up-to-date:
  bazel-bin/demo-2.out
$ cat bazel-bin/demo-2.out
output:             bazel-out/k8-fastbuild/bin/demo-2.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   2.0.0
```

### Transition to specific toolchain version

```shell
$ bazel build demo-all-1 --toolchain_resolution_debug=//toolchains:toolchain_type
... Selected //toolchains:demo-x86_64-linux-x86_64-linux-1.0.0
... bazel-bin/demo-all.out
$ cat bazel-bin/demo-all.out
output:             bazel-out/k8-fastbuild/bin/demo-all.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   1.0.0
```

```shell
$ bazel build demo-all-1.1 --toolchain_resolution_debug=//toolchains:toolchain_type
... Selected //toolchains:demo-x86_64-linux-x86_64-linux-1.1.0
... bazel-out/k8-fastbuild-ST-f2f601e3226f/bin/demo-all.out
$ cat bazel-out/k8-fastbuild-ST-f2f601e3226f/bin/demo-all.out
output:             bazel-out/k8-fastbuild-ST-f2f601e3226f/bin/demo-all.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   1.1.0
```

```shell
$ bazel build demo-all-2 --toolchain_resolution_debug=//toolchains:toolchain_type
... Selected //toolchains:demo-x86_64-linux-x86_64-linux-2.0.0
... bazel-out/k8-fastbuild-ST-6d692ac628d1/bin/demo-all.out
$ cat bazel-out/k8-fastbuild-ST-6d692ac628d1/bin/demo-all.out
output:             bazel-out/k8-fastbuild-ST-6d692ac628d1/bin/demo-all.out
execution platform: x86_64-linux
target platform:    x86_64-linux
compiler version:   2.0.0
```
