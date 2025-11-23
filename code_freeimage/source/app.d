// BindBC imports
import bindbc.freeimage;
import bindbc.loader.sharedlib;

import core.stdc.stdio;


/// Entry point compatible with betterC
extern(C) int main(int argc, char** argv)
{
    if (argc < 2) {
        printf("Usage: program <imagefile>\n");
        return 1;
    }

    // Load FreeImage library
    auto status = loadFreeImage("lib/libFreeImage.dylib");

    //if (status == FISupport.noLibrary) {
    //    printf("Failed to load FreeImage shared library.\n");
    //    return 2;
    //}
    //else if (status == FISupport.badLibrary) {
    //    printf("Bad FreeImage shared library.\n");
    //    return 2;
    //}

    const char* filename = argv[1];

    // Detect file format
    FREE_IMAGE_FORMAT fif = FreeImage_GetFileType(filename, 0);
    if (fif == FIF_UNKNOWN)
        fif = FreeImage_GetFIFFromFilename(filename);

    if (fif == FIF_UNKNOWN) {
        printf("Could not detect file format.\n");
        return 3;
    }

    // Load image
    FIBITMAP* bmp = FreeImage_Load(fif, filename);
    if (bmp is null) {
        printf("Failed to load image: %s\n", filename);
        return 4;
    }

    const uint width  = FreeImage_GetWidth(bmp);
    const uint height = FreeImage_GetHeight(bmp);
    const uint bpp    = FreeImage_GetBPP(bmp);

    if (width == 0 || height == 0) {
        printf("Invalid image dimensions.\n");
        FreeImage_Unload(bmp);
        return 5;
    }

    // Convert to 24bpp for easy RGB access
    FIBITMAP* bitmap24 = bmp;
    if (bpp != 24) {
        bitmap24 = FreeImage_ConvertTo24Bits(bmp);
        FreeImage_Unload(bmp);
        if (bitmap24 is null) {
            printf("Failed to convert to 24-bit.\n");
            return 6;
        }
    }

    ulong sumR = 0, sumG = 0, sumB = 0;

    // Iterate through pixels
    for (uint y = 0; y < height; ++y) {
        BYTE* bits = cast(BYTE*)FreeImage_GetScanLine(bitmap24, y);

        for (uint x = 0; x < width; ++x) {
            // In FreeImage, pixels are stored in order
            BYTE r = bits[x * 3 + 0];
            BYTE g = bits[x * 3 + 1];
            BYTE b = bits[x * 3 + 2];

            sumR += r;
            sumG += g;
            sumB += b;
        }
    }

    // Print results
    printf("Image: %s\n", filename);
    printf("Width: %u, Height: %u\n", width, height);
    printf("Sum R: %lu\n", sumR);
    printf("Sum G: %lu\n", sumG);
    printf("Sum B: %lu\n", sumB);

    FreeImage_Unload(bitmap24);
    return 0;
}
