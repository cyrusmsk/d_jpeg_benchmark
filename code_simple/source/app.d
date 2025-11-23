import simple_image;
import std.stdio;

void main(string[] args) {
    if (args.length < 2) {
        writeln(i"Usage: $(args[0]) <image.jpg>\n");
        return;
    }

    writeln(args[1]);

    auto image = args[1].loadImageRgb();


    ulong sumR, sumG, sumB;
    foreach(y; 0 .. image.height) {
        foreach(x; 0 .. image.width) {
            sumR += image.pixel(x, y)[0];
            sumG += image.pixel(x, y)[1];
            sumB += image.pixel(x, y)[2];
        }
    }

    writeln(i"Width: $(image.width), Height: $(image.height), Pixels: $(image.width*image.height)");
    writeln(i"Sum R = $(sumR)");
    writeln(i"Sum G = $(sumG)");
    writeln(i"Sum B = $(sumB)");

}
