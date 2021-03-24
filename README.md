# EggChamberScaling

## Requirements

1. MATLAB (versions 2018b and 2019b were used in creating codes)
2. [ilastik](https://www.ilastik.org/) (versions 1.3.0 and 1.3.2 were used for training)
3. FIJI (for image pre-processing)
4. the following MATLAB open-source programs: [munkres.m](https://www.mathworks.com/matlabcentral/fileexchange/20328-munkres-assignment-algorithm), some version of [imagesc3D.m](https://www.mathworks.com/matlabcentral/fileexchange/66638-imagesc3d)

## Getting Started

Clone the repository:
    
    git clone https://github.com/Shvartsman-Lab/EggChamberScaling.git
    
## Running Codes

Egg_Chamber_Reconstruct.m is the main hub for all reconstructions and should be used as the main script.  This script runs the functions ilastikMembraneSegment.m, ilastikRingFinder.m, and ilastikTreeMatch.m, which are described in more detail below.

Each channel in the study (membrane, DNA content, nucleoli, and ring canals) need to have a corresponding probability map from ilastik.  These probability outputs may have different paths, which will need to be changed in the main script, Egg_Chamber_Reconstruct.m, in the first section.  In addition, the permutation needed to get (x,y,z,c) may need to be altered based on how the data from ilastik was saved.

ilastikMembraneSegment.m will use the trained probability output from ilastik of cell membrane locations to seed the locations of the cells in the egg chamber.  The smoothing kernel used on the membrane probabilities can be changed in the function, but it is recommended to use some multiple of (x x 2x) as a filter.

ilastikRingFinder.m will use the trained probability output from ilastik of ring canal locations to identify which objects identified from ilastikMembraneSegment.m (aka the cells of the egg chamber) are adjacent.  The threshold for ring probability by default is 0.5, but this can be manually edited as needed.

ilastikTreeMatch.m will take the known cell locations and the known adjacencies of the cells and redistribute them according to the known adjacencies of the cells in the Drosophila egg chamber.  This can be easily changed for any system where the connections between cells are known and invariant across samples.  The output of this function should be an egg chamber with the correct cell labels for each cell in the cyst.

All scripts and functions have been given comments to help guide the purpose of each step, as well as explain where changes may need to be made for accurate segmentation.

Finally, EC_measurements.m can be used to analyze data in a similar way as the paper. This data by default runs off the cleaned version of collected data from fixed imaging experiments, but the path can be changed as needed for other analyses of other datasets.

## Visualization

After reconstructing an egg chamber using the above codes, Egg_Chamber_Reconstruct_Visualize.m will build a 3D rendering of the nurse cells (based on number of ring canals away from the oocyte), as well as an egg chamber that is translucent and shows the DNA and nucleolar regions of each nurse cell nucleus.
