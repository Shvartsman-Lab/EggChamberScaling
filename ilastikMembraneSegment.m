function [newimage, volumeout, props] = ilastikMembraneSegment(image, voxelSize, kernel, threshold, varargin)
%Segment an input image of membranes to yield objects and their volumes.

%set the minimum and maximum sizes for objects relative to the volume of
%the full stack
minvolscale = 5e-3;
maxvolscale = 0.2;

%set up filter for watershed
H = fspecial3('gaussian', [kernel(1) kernel(2) kernel(3)]); %make special Gausian smoothing kernel
seeded = conv3fft(image, H); %run over stack
seeded(seeded < threshold) = -Inf; %set seeds for watershed
ws = watershed(seeded, 6); %run watershed algorithm over stack to create objects

%find objects by running connected components algorithm
objects = bwconncomp(ws, 6);
[~, order] = sort(cellfun(@length, objects.PixelIdxList), 'descend'); %sort by size
objects.PixelIdxList = objects.PixelIdxList(order); %rearrange list by sorting performed in previous step
props = regionprops(objects,'Area','BoundingBox','Centroid','PixelIdxList','PixelList'); %extract properties of all objects isolated

%find min and max volumes for object pruning
minvol = minvolscale*size(image,1)*size(image,2)*size(image,3);
maxvol = maxvolscale*size(image,1)*size(image,2)*size(image,3);

%remove objects that don't fall within volume range or that have portions
%that touch any part of the boundary (egg chamber is totally within volume)
check = false(length(props),1);
for i = 1:length(props)
    check(i) = props(i).Area > minvol && props(i).Area < maxvol && props(i).BoundingBox(1) ~= 0.5 && props(i).BoundingBox(2) ~= 0.5 && props(i).BoundingBox(3) ~= 0.5 && (props(i).BoundingBox(1)+props(i).BoundingBox(4) ~= size(seeded,2)+0.5) && (props(i).BoundingBox(2)+props(i).BoundingBox(5) ~= size(seeded,1)+0.5) && (props(i).BoundingBox(3)+props(i).BoundingBox(6) ~= size(seeded,3)+0.5);
end
props = props(check == 1);

check2 = false(length(props),1);
for j = 1:length(props)
        check2(j) = sum(props(j).PixelList(:,1) == 1) + sum(props(j).PixelList(:,2) == 1) + sum(props(j).PixelList(:,1) == size(seeded,2)) + sum(props(j).PixelList(:,2) == size(seeded,1));
end

props = props(check2 == 0);
% props = props([1:2,4:17]); %can edit the properties if you want to
% specifically throwout some of the objects found by the program

%get volumes of leftover objects
volumeout = zeros(length(props),1);

%correct volumes by voxel size
for k = 1:length(props)
    volumeout(k) = props(k).Area*voxelSize(1)*voxelSize(2)*voxelSize(3);
end

%export new image with membrane segmentation done!
newimage = zeros(size(image));
for m = 1:length(props)
    newimage(props(m).PixelIdxList) = m;
end

end