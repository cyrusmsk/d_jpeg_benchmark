import std.stdio;
import gamut;

void main(string[] args) {
    if (args.length < 2) {
        writeln(i"Usage: $(args[0]) <image.jpg>\n");
        return;
    }

    Image image;
    image.loadFromFile(args[1], LOAD_RGB | LOAD_ALPHA | LOAD_8BIT | LOAD_NO_PREMUL);

    if (image.isError)
    {
        throw new Exception("Couldn't open file " ~ args[1]);
    }

    ulong sumR, sumG, sumB;

    assert(image.hasData());
    for (int y = 0; y < image.height; y++)
    {
        ubyte* scan = cast(ubyte*) image.scanptr(y);
        for (int x = 0; x < image.width; x++)
        {
            //if ((y == 0) && (x == 1))
            //    writeln(scan[4*x+0], " ", scan[4*x+1], " ", scan[4*x+2]);
            sumR += scan[4*x + 0];
            sumG += scan[4*x + 1];
            sumB += scan[4*x + 2];
        }
    }
    
    writeln(i"Width: $(image.width), Height: $(image.height), Pixels: $(image.width*image.height)");
    writeln("Sum R = ", sumR);
    writeln("Sum G = ", sumG);
    writeln("Sum B = ", sumB);
}
