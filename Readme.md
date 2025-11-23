# JPEG benchmark
The benchmark code was mostly designed to test available libraries for the D language.

As a popular references also were used:
- C library libjpeg-turbo
- PIL Python package

From the D side were tested:
- simple std_image bindings
- libjpeg-turbo bindings
- imageformats library
- gamut library

## Folder with library files
FreeImage library currently configured to work with dynamic linking.
So you need to create a folder "lib" and put files there:
```
libFreeImage.dylib
libLibJXR.a
libLibRAW.a
```

For turbojpeg also to the folder "code_turbojpeg" add:
```
libturbojpeg.a
```
And the same file need to be placed to "code_d_turbo/lib".

For other libraries maybe will be required to install to the system.

## Task for the benchmark
Open the JPEG file in RGB format.
And calculate sum of R, G and B channels.
Print the result to the console.

## Results
For tests were used 2 files:
- small.jpg
- sample-jpg-file-for-testing.jpg


### Small file result
```bash
Summary
  code_turbojpeg/code_turbojpeg ./small.jpg ran
    1.03 ± 0.01 times faster than code_freeimage/code_freeimage ./small.jpg
    1.13 ± 0.01 times faster than code_d_turbo/code_d_turbo ./small.jpg
    3.63 ± 0.04 times faster than code_simple/code_simple ./small.jpg
    4.74 ± 0.05 times faster than code_imageformats/code_imageformats ./small.jpg
    6.47 ± 0.06 times faster than code_gamut/code_gamut ./small.jpg
```

### Large file result
```
Summary
  code_freeimage/code_freeimage ./sample-jpg-file-for-testing.jpg ran
    1.00 ± 0.01 times faster than code_turbojpeg/code_turbojpeg ./sample-jpg-file-for-testing.jpg
    1.09 ± 0.01 times faster than code_d_turbo/code_d_turbo ./sample-jpg-file-for-testing.jpg
    2.99 ± 0.02 times faster than code_simple/code_simple ./sample-jpg-file-for-testing.jpg
    3.39 ± 0.07 times faster than python ./code_pil/code.py ./sample-jpg-file-for-testing.jpg
    5.10 ± 0.05 times faster than code_imageformats/code_imageformats ./sample-jpg-file-for-testing.jpg
```

## Build
Every D library was built with
```bash
dub build -b=release
```

C library was built with:
```bash
clang -O3 code.c -o code_turbojpeg -L./ -lturbojpeg 
```

## References
- [Image sources](https://www.learningcontainer.com/sample-jpeg-file-download-for-testing/)
