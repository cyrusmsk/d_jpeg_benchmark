#include <stdio.h>
#include <stdlib.h>
#include "turbojpeg.h"

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s <image.jpg>\n", argv[0]);
        return 1;
    }

    const char* filename = argv[1];
    tjhandle tj = NULL;
    unsigned char *jpegBuf = NULL, *rgbBuf = NULL;
    long jpegSize = 0;
    int width, height, jpegSubsamp, jpegColorspace;
    FILE *f = NULL;

    // ---- Read entire JPEG file ----
    f = fopen(filename, "rb");
    if (!f) {
        perror("fopen");
        return 1;
    }
    fseek(f, 0, SEEK_END);
    jpegSize = ftell(f);
    fseek(f, 0, SEEK_SET);

    jpegBuf = (unsigned char*)malloc(jpegSize);
    fread(jpegBuf, jpegSize, 1, f);
    fclose(f);

    // ---- Decompress JPEG header ----
    tj = tjInitDecompress();
    if (!tj) {
        fprintf(stderr, "tjInitDecompress error: %s\n", tjGetErrorStr());
        return 1;
    }

    if (tjDecompressHeader3(tj, jpegBuf, jpegSize,
                            &width, &height,
                            &jpegSubsamp, &jpegColorspace)) {
        fprintf(stderr, "tjDecompressHeader3 error: %s\n", tjGetErrorStr());
        return 1;
    }

    // ---- Allocate RGB buffer ----
    rgbBuf = (unsigned char*)malloc(width * height * 3);
    if (!rgbBuf) {
        perror("malloc");
        return 1;
    }

    // ---- Decompress to RGB ----
    if (tjDecompress2(tj, jpegBuf, jpegSize,
                      rgbBuf, width, 0 /*pitch*/, height,
                      TJPF_RGB, TJFLAG_FASTDCT)) {
        fprintf(stderr, "tjDecompress2 error: %s\n", tjGetErrorStr());
        return 1;
    }

    // ---- Sum RGB channels ----
    unsigned long long sumR = 0, sumG = 0, sumB = 0;
    long totalPixels = width * height;

    for (long i = 0; i < totalPixels; i++) {
        sumR += rgbBuf[i * 3 + 0];
        sumG += rgbBuf[i * 3 + 1];
        sumB += rgbBuf[i * 3 + 2];
    }

    // ---- Print results ----
    printf("Width: %d, Height: %d, Pixels: %ld\n", width, height, totalPixels);
    printf("Sum R = %llu\n", sumR);
    printf("Sum G = %llu\n", sumG);
    printf("Sum B = %llu\n", sumB);

    // ---- Cleanup ----
    tjDestroy(tj);
    free(jpegBuf);
    free(rgbBuf);

    return 0;
}
