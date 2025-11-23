from PIL import Image
import numpy as np
import sys

def sum_rgb(filename):
    img = Image.open(filename).convert("RGB")
    arr = np.array(img)      # shape: (H, W, 3)
    
    sum_r = arr[:, :, 0].sum()
    sum_g = arr[:, :, 1].sum()
    sum_b = arr[:, :, 2].sum()
    
    print("Sum R =", sum_r)
    print("Sum G =", sum_g)
    print("Sum B =", sum_b)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python code.py <image.jpg>")
        sys.exit(1)

    filename = sys.argv[1]  # ← file name from argument

    sum_rgb(filename)
