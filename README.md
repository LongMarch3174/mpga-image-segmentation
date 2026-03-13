# MPGA Image Segmentation

A MATLAB-based image segmentation project that combines:

- **Frequency-domain preprocessing** (low-pass filtering)
- **Otsu objective function**
- **Multi-Population Genetic Algorithm (MPGA)** for adaptive threshold search

The repository also includes a simple fixed-threshold baseline script for comparison.

## Features

- Converts the input image to grayscale.
- Applies low-pass filtering in the frequency domain to suppress high-frequency noise.
- Uses MPGA to search for an optimal binary segmentation threshold.
- Outputs segmentation results in both **PNG** and **EMF** formats.
- Plots and exports the evolutionary optimization curve.

## Repository Structure

- `mpga.m`: End-to-end pipeline (preprocess -> MPGA optimization -> segmentation).
- `main.m`: Simple baseline segmentation with a fixed threshold (`102`).
- `pre.m`: Standalone preprocessing script.
- `OTSU.m`: Otsu between-class variance objective function.
- `immigrant.m`: Migration operator between sub-populations.
- `EliteInduvidual.m`: Elite retention / artificial selection operator.

## Input and Output Files

### Input

- `sample.png`: source image used by scripts.

### Generated Outputs

- `gray_sample.png`: grayscale image.
- `preprocessed_sample.png`: filtered image for threshold search.
- `evolution_process.emf`: optimization process curve.
- `segmented_image.png`: final binary segmentation result.
- `segmented_image.emf`: EMF export of final segmented image.

## Requirements

- MATLAB (recommended R2018+).
- Image Processing Toolbox (for functions like `imread`, `imwrite`, `imhist`, `imshow`).
- GA toolbox functions used in `mpga.m`:
  - `crtbp`, `bs2rv`, `ranking`, `select`, `recombin`, `mut`, `reins`

> If these GA functions are unavailable in your MATLAB environment, install a compatible GA toolbox (for example, GEATbx-style APIs) or replace them with equivalent built-in MATLAB Genetic Algorithm workflow.

## Quick Start

1. Put your test image in the project root and name it `sample.png` (or edit the script paths).
2. Run the full MPGA pipeline:

```matlab
mpga
```

3. Check generated outputs in the project root.

## Baseline (Fixed Threshold)

To run the simple fixed-threshold version:

```matlab
main
```

This script directly binarizes grayscale pixels using threshold `102` and exports `segmented_image.emf`.

## Notes

- `OTSU.m` reads `preprocessed_sample.png`, so run preprocessing first (or run `mpga.m`, which already handles preprocessing).
- The current scripts assume 8-bit grayscale range `[0, 255]`.
- You can tune MPGA settings in `mpga.m` (e.g., population size, crossover/mutation rates, and generation limits) for different images.

## License

This project is distributed under the terms in [LICENSE](LICENSE).
