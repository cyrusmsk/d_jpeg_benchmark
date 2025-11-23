import std.stdio;
import imageformats;

void main(string[] args) {
    if (args.length < 2) {
        writefln("Usage: %s <image.jpg>", args[0]);
        return;
    }

    try {
        IFImage image = read_image(args[1], ColFmt.RGB);
        ulong sumR, sumG, sumB;

        writeln(image.pixels.length);

        for (size_t i = 0; i < image.pixels.length; i += 3) {
            sumR += image.pixels[i];
            sumG += image.pixels[i+1];
            sumB += image.pixels[i+2];
        }

        writefln("Width: %d, Height: %d, Pixels: %d\n", image.w, image.h, image.w * image.h);
        writeln("Sum R = ", sumR);
        writeln("Sum G = ", sumG);
        writeln("Sum B = ", sumB);
    } catch (Exception e) {
        writeln("Exception: ", e);
    }
    
}
