%% Input sample for reconstruction
slide_num = 2; %slide sample being observed
sample_num = 1; %sample number from slide of egg chamber being analyzed
voxelSize = [0.2405 0.2405 0.2518]; %set voxel size based on FIJI info

%import probability maps from ilastik (requires ilastik training on
%stack/sample first) 

% FOLDER NAME WILL NEED TO BE CHANGED BASED ON YOUR PATH!! %%%
memb_sample = strcat(['C:\Users\rockyd\Desktop\Egg Chambers\wild type\Egg Chambers\Trained\Phal_',num2str(slide_num)','_',num2str(sample_num),'_Probabilities.h5']);
nuc_sample = strcat(['C:\Users\rockyd\Desktop\Egg Chambers\wild type\Egg Chambers\Trained\Dapi.Fib_',num2str(slide_num)','_',num2str(sample_num),'_Probabilities.h5']);
ring_sample = strcat(['C:\Users\rockyd\Desktop\Egg Chambers\wild type\Egg Chambers\Trained\Phospho_',num2str(slide_num)','_',num2str(sample_num),'_Probabilities.h5']);

%for membrane, open stack, switch around axes (to get to x,y,z,c),
%normalize everything to [0 1], then save the first channel as membrane signal 
uiopen(memb_sample,1);
image_memb = double(I.img);
image_memb = permute(image_memb, [2 3 4 1]);
image_memb = image_memb./max(image_memb(:));
memb = image_memb(:,:,:,1);

%for DNA/nuclei, open stack, switch around axes (to get to x,y,z,c),
%normalize everything to [0 1], then save the first channel as nucleoli
%signal and the second as nuclear (DNA) signal
uiopen(nuc_sample,1);
image_nuc = double(I.img);
image_nuc = permute(image_nuc, [1 2 4 3]);
image_nuc = image_nuc./max(image_nuc(:));
nucleoli = image_nuc(:,:,:,1);
nuclei = image_nuc(:,:,:,2);

%for rings, open stack, switch around axes (to get to x,y,z,c),
%normalize everything to [0 1], then save the first channel as ring signal
uiopen(ring_sample,1);
image_ring = double(I.img);
image_ring = permute(image_ring, [2 3 4 1]);
image_ring = image_ring./max(image_ring(:));
ring = image_ring(:,:,:,1);

% figure; imagesc3D(memb); colorbar; %optional: can visualize each channel as desired

% run segmentation for membranes to isolate all 16 cells
[newimagememb, volumeout, membprops] = ilastikMembraneSegment(memb, voxelSize, [24 24 12], 0.05); %input to fxn: memb sample, voxelSize, kernel for smoothing, seeding threshold
%output of fxn is: segmented membranes -> cells, volumes of each cell,
%properties of each cell found

figure; imagesc3D(newimagememb); colorbar; %optional: view output from segmentation to confirm it has worked properly

%% Reconstruct nucleoli and DNA for all nurse cells
% set volumes of nuclei and nucleoli (16 objects for egg chambers)
nucleusvol = zeros(16,1);
nucleolusvol = zeros(16,1);

% for each object, find corresponding nucleus and extract volume of the DNA
% and of the nucleoli in each cell
for i = 1:16
nucleusvol(i) = sum(sum(sum(nuclei.*(newimagememb == i) > 0.5)))*voxelSize(1)*voxelSize(2)*voxelSize(3);
nucleolusvol(i) = sum(sum(sum(nucleoli.*(newimagememb == i) > 0.5)))*voxelSize(1)*voxelSize(2)*voxelSize(3);
end

%minimum amount should be in the oocyte, since its nucleus is quiescent and should not have strong staining of either marker 
minimum = min(nucleusvol+nucleolusvol);
oocyte = find((nucleusvol+nucleolusvol == minimum));

%perform ring segmentation and isolation to get proper assignment of nurse
%cell identities
[newimagering, newimage, matchup, ringprops, prop_pairs] = ilastikRingFinder(ring, newimagememb, 0.5); %input to fxn: ring sample, segmented membranes, ring threshold probability
%output of fxn is: segmented rings, info on which object each ring lies in
%(as stack), matchup matrix of who is connected to whom, properties of each
%ring, and which pairs of cells are adjacent
%% Isolate rings in sample to find all connections between cells
[output_cells, cell_volumes, output_cell_props, permutation] = ilastikTreeMatch(matchup, voxelSize, membprops, newimagememb, oocyte); %input to fxn: matchup matrix, voxel size, nurse cell properties, membrane segmentation output, identity of oocyte
%output of fxn is: updated assignment stacks with proper cell identity,
%volumes of the cells after correction, properties of each cell, and the
%permutation vector used for reassignment

imagesc3D(output_cells); colorbar; %optional: view egg chamber after reassignment of object identites

%redo nuclear volume measurement with updated identity information
nucleusvol = zeros(16,1);
nucleolusvol = zeros(16,1);

for i = 2:16 %ignore oocyte (i=1)
nucleusvol(i) = sum(sum(sum(nuclei.*(output_cells == i) > 0.5)))*voxelSize(1)*voxelSize(2)*voxelSize(3);
nucleolusvol(i) = sum(sum(sum(nucleoli.*(output_cells == i) > 0.5)))*voxelSize(1)*voxelSize(2)*voxelSize(3);
end
%total nuclear region is DNA + nucleolar region
total_nuc = nucleusvol+nucleolusvol;

%stats to keep for further analysis: [cell volume, volume fraction (of
%total), volumes of DNA, volumes of nucleolar regions]
output_stats = [cell_volumes' (cell_volumes./(sum(cell_volumes)))' nucleusvol nucleolusvol total_nuc];

%get cell volume rankings (minus oocyte)
cell_vol_ranks = zeros(15,1);
nuc_vol_ranks = zeros(15,1);

%get cell volume fractions rankings (minus oocyte)
NC_cell_vols = cell_volumes(2:end)';
NC_nuc_vols = total_nuc(2:end);

[~,cell_ranks] = sort(NC_cell_vols,'descend');
[~,nuc_ranks] = sort(NC_nuc_vols,'descend');
for i = 1:15
    cell_vol_ranks(cell_ranks(i)) = i;
    nuc_vol_ranks(nuc_ranks(i)) = i;
end

%set oocyte to NaN to not throw off data analysis
cell_vol_ranks = [NaN; cell_vol_ranks];
nuc_vol_ranks = [NaN; nuc_vol_ranks];

NC_cell_vol_frac = NC_cell_vols./sum(NC_cell_vols);
NC_nuc_vol_frac = NC_nuc_vols./sum(NC_nuc_vols);

NC_cell_vol_frac = [NaN; NC_cell_vol_frac];
NC_nuc_vol_frac = [NaN; NC_nuc_vol_frac];

%additional columns: nurse cell volume rank, nurse cell nuclear volume
%rank, nurse cell volume fraction (w/o oocyte), nurse cell nuclear volume 
%fraction (w/o oocyte)
output_stats = [output_stats cell_vol_ranks nuc_vol_ranks NC_cell_vol_frac NC_nuc_vol_frac];

