function [newimagering, newimage, newmatchup, props, matchup] = ilastikRingFinder(image, newimagememb, thresh)
% set min and max volumes for rings (much smaller than membranes)
minvolscale = 2e-5;
maxvolscale = 5e-4;

%for ring input, find where the probability is greater than the threshold,
%and find the intersection with the membrane output
newring = bwlabeln((image > thresh).*newimagememb);

%clean rings by skeletonizing until converged (no changes after loop)
s = bwskel(newring > 0);
change_occur = true;
while change_occur
    new_s = s;
    new_s(bwmorph3(s,'endpoints')) = false;
    change_occur = ~isequal(new_s, s);
    s = new_s;
end

%keep surviving rings and relabel
s = bwmorph3(s, 'clean');
rings_to_keep = integer_unique(nonzeros(newring(s)));
newring(~ismember(newring, rings_to_keep)) = 0;
image = bwlabeln(newring > 0);

%run connected components on all rings for size
conncomp = bwconncomp(image);

% sort according to size
[~, order] = sort(cellfun(@length, conncomp.PixelIdxList), 'descend');
conncomp.PixelIdxList = conncomp.PixelIdxList(order); %reorder based on size
props = regionprops(conncomp,'Area','BoundingBox','Centroid','SubArrayIdx','FilledArea','PixelIdxList','PixelList'); %extract ring properties

%find min and max volumes for object pruning 
minvol = minvolscale*size(image,1)*size(image,2)*size(image,3);
maxvol = maxvolscale*size(image,1)*size(image,2)*size(image,3);

%remove objects that don't fall within volume range or that have portions
%that touch any part of the boundary (egg chamber is totally within volume)
check = false(length(props),1);
for i = 1:length(props)
    check(i) = props(i).Area > minvol && props(i).Area < maxvol && props(i).BoundingBox(1) ~= 0.5 && props(i).BoundingBox(2) ~= 0.5;
end

props = props(check == 1);
check2 = false(length(props),1);
for j = 1:length(props)
    check2(j) = sum(props(j).PixelList(:,1) == 1) + sum(props(j).PixelList(:,2) == 1) + sum(props(j).PixelList(:,3) == 1) + sum(props(j).PixelList(:,1) == size(image,2)) + sum(props(j).PixelList(:,2) == size(image,1)) + sum(props(j).PixelList(:,3) == size(image,1));
end

props = props(check2 == 0);

%assign ring labels after pruning
newimagering = zeros(size(image));
for m = 1:length(props)
    newimagering(props(m).PixelIdxList) = m;
end

%for each ring, list all pixels in stack that belong to it
for i = 1:length(props)
    list{i} = props(i).PixelIdxList;
end
newimage = newimagememb.*(newimagering > 0);

%initial matchup vector based on number of rings found
matchup = zeros(length(list),2);
for j = 1:length(list)
    %for each ring, get list of pixels
    output = newimage(list{j});
    
    %for each cell (assuming there are 16), find out how many pixels belong
    %to that cell object number
    number = zeros(1,16);
    for k = 1:16
        number(k) = sum(output == k);
    end
    
    %if ring (or object thought to be a ring) does not have 2 connections,
    %then add new matchup vector of [0 0]
    %if ring (or object thought to be a ring) does have 2 connections,
    %then add new matchup vector with these object identities
    %if ring (or object thought to be a ring) has more than 2 connections,
    %then add new matchup vector with the 2 objects with the most number of
    %pixels (should only be issue near a tricellular junction, etc.)
    if nnz(number) < 2
        matchup(j,1) = 0;
        matchup(j,2) = 0;
    elseif max(number) == max(number(number < max(number)))
        matchup(j,1) = find(number == max(number));
        matchup(j,2) = find(number == max(number));
    else
        matchup(j,1) = find(number == max(number));
        matchup(j,2) = find(number == max(number(number<max(number))));
    end
end

% Remove zero rows and rows with one element
rule = matchup(:,2) == 0;
matchup(rule,:) = [];

% Remove zero columns
matchup(:,all(~matchup,1)) = [];

%flip matchup matrix and then remove duplicates so only unique pairs left
matchupswitch = [matchup(:,2) matchup(:,1)];
newmatchup = unique([matchup; matchupswitch], 'rows');

%Remove duplicate pairs
pair = newmatchup(:,1) < newmatchup(:,2);
newmatchup = newmatchup.*pair;
rule = newmatchup(:,2) == 0;

%remove zeros and export matchup matrix
newmatchup(rule,:) = [];
end

