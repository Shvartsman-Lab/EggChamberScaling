function [output_cells, cell_volumes, newprops, permutation] = ilastikTreeMatch(matchup, voxelSize, membprops, newimagememb, oocyte)

%known adjacency matrix for 16 cell egg chamber
truematchup = [1  2; 1  3; 1  5; 1  9;
    2  4; 2  6; 2 10; 3  7;
    3 11; 4 12; 4  8; 5 13;
    6 14; 7 15; 8 16];

%set actual matchup matrix based on known connections
truematchupmatrix = zeros(16);
for i = 1:size(truematchup,1)
    %for each matchup, add a 1 to location (i,j) for i,j being the numbers
    %of the cells that are connected
    truematchupmatrix(truematchup(i,1),truematchup(i,2)) = 1;
    truematchupmatrix(truematchup(i,2),truematchup(i,1)) = 1;
end

%set matrix up for connections between objects enumerated in previous parts
matchupmatrix = zeros(16);
for i = 1:size(matchup,1)
     %for each matchup, add a 1 to location (i,j) for i,j being the numbers
    %of the cells that are connected
    matchupmatrix(matchup(i,1),matchup(i,2)) = 1;
    matchupmatrix(matchup(i,2),matchup(i,1)) = 1;
end

%oocyte is important (breaks symmetry of cyst), so multiply its row and
%column by 2 to distinguish it from other cell with 4 connections
matchupmatrix(oocyte,:) = 2*matchupmatrix(oocyte,:);
matchupmatrix(:,oocyte) = 2*matchupmatrix(:,oocyte);

%oocyte is important (breaks symmetry of cyst), so multiply its row and
%column by 2 to distinguish it from other cell with 4 connections
truematchupmatrix(1,:) = 2*truematchupmatrix(1,:);
truematchupmatrix(:,1) = 2*truematchupmatrix(:,1);

%based on previous papers, get eigenvectors for each matrix and multiply
[P1, ~] = eig(truematchupmatrix);
[P2, ~] = eig(matchupmatrix);

P1 = abs(P1);
P2 = abs(P2);

outputmatrix = P2*P1';
%run munkres (Hungarian) algorithm over this product to get proper
%assignment
[permutation, ~] = munkres(outputmatrix);

%permutation is # cells (16) + 1 = 17 - previous assignment
permutation = (17 - permutation)';

%reassign volumes, identities, and properties based on the new permutation 
%putting the cells with their proper labels
for i = 1:16
    newprops(permutation(i)) = membprops(i);
end

output_cells = zeros(size(newimagememb));
for m = 1:length(newprops)
    output_cells(newprops(m).PixelIdxList) = m;
end

cell_volumes = zeros(length(newprops),1);
for k = 1:length(newprops)
    cell_volumes(k) = newprops(k).Area*voxelSize(1)*voxelSize(2)*voxelSize(3);
end
cell_volumes = cell_volumes';
end