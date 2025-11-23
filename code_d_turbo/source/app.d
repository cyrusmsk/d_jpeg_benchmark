import std.file : read, write;
import std.stdio : writefln, writeln;

import jpeg_turbod;

void main(string[] args)
{
    if (args.length < 2) {
        writeln(i"Usage: $(args[0]) <image.jpg>\n");
        return;
    }
    
    const auto jpegFile = args[1];
    auto jpegInput = cast(ubyte[]) jpegFile.read;

    auto dc = new Decompressor();
    ubyte[] pixels;
    int width, height;
    bool decompressed = dc.decompress(jpegInput, pixels, width, height);

    if (decompressed)
    {
        ulong sumR, sumG, sumB;
        for(int i = 0; i < pixels.length / 3; i++) {
            sumR += pixels[3*i];
            sumG += pixels[3*i+1];
            sumB += pixels[3*i+2];
        }

        writeln(i"Width: $(width), Height: $(height), Pixels: $(width*height)");
        writeln("Sum R = ", sumR);
        writeln("Sum G = ", sumG);
        writeln("Sum B = ", sumB);
    }
    else
    {
        dc.errorInfo.writeln;
        return;
    }
}
