%% Reconstruct egg chamber with colors in full 3D

opac = 0.5; %set desired opacity
voxelSize = [0.2405 0.2405 0.2518]; %set voxel size based on FIJI info

p1 = isosurface(output_cells == 1);
p1.vertices(:,1:2) = p1.vertices(:,1:2)*voxelSize(1);
p1.vertices(:,3) = p1.vertices(:,3)*voxelSize(3);
patch(p1,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(opac)

p2 = isosurface(output_cells == 2);
p2.vertices(:,1:2) = p2.vertices(:,1:2)*voxelSize(1);
p2.vertices(:,3) = p2.vertices(:,3)*voxelSize(3);
patch(p2,'FaceColor',[92/255 157/255 178/255],'EdgeColor','none'); axis image; alpha(opac)

p3 = isosurface(output_cells == 3);
p3.vertices(:,1:2) = p3.vertices(:,1:2)*voxelSize(1);
p3.vertices(:,3) = p3.vertices(:,3)*voxelSize(3);
patch(p3,'FaceColor',[92/255 157/255 178/255],'EdgeColor','none'); axis image; alpha(opac)

p4 = isosurface(output_cells == 4);
p4.vertices(:,1:2) = p4.vertices(:,1:2)*voxelSize(1);
p4.vertices(:,3) = p4.vertices(:,3)*voxelSize(3);
patch(p4,'FaceColor',[180/255 67/255 59/255],'EdgeColor','none'); axis image; alpha(opac)

p5 = isosurface(output_cells == 5);
p5.vertices(:,1:2) = p5.vertices(:,1:2)*voxelSize(1);
p5.vertices(:,3) = p5.vertices(:,3)*voxelSize(3);
patch(p5,'FaceColor',[92/255 157/255 178/255],'EdgeColor','none'); axis image; alpha(opac)

p6 = isosurface(output_cells == 6);
p6.vertices(:,1:2) = p6.vertices(:,1:2)*voxelSize(1);
p6.vertices(:,3) = p6.vertices(:,3)*voxelSize(3);
patch(p6,'FaceColor',[180/255 67/255 59/255],'EdgeColor','none'); axis image; alpha(opac)

p7 = isosurface(output_cells == 7);
p7.vertices(:,1:2) = p7.vertices(:,1:2)*voxelSize(1);
p7.vertices(:,3) = p7.vertices(:,3)*voxelSize(3);
patch(p7,'FaceColor',[180/255 67/255 59/255],'EdgeColor','none'); axis image; alpha(opac)

p8 = isosurface(output_cells == 8);
p8.vertices(:,1:2) = p8.vertices(:,1:2)*voxelSize(1);
p8.vertices(:,3) = p8.vertices(:,3)*voxelSize(3);
patch(p8,'FaceColor',[45/255 99/255 68/255],'EdgeColor','none'); axis image; alpha(opac)

p9 = isosurface(output_cells == 9);
p9.vertices(:,1:2) = p9.vertices(:,1:2)*voxelSize(1);
p9.vertices(:,3) = p9.vertices(:,3)*voxelSize(3);
patch(p9,'FaceColor',[92/255 157/255 178/255],'EdgeColor','none'); axis image; alpha(opac)

p10 = isosurface(output_cells == 10);
p10.vertices(:,1:2) = p10.vertices(:,1:2)*voxelSize(1);
p10.vertices(:,3) = p10.vertices(:,3)*voxelSize(3);
patch(p10,'FaceColor',[180/255 67/255 59/255],'EdgeColor','none'); axis image; alpha(opac)

p11 = isosurface(output_cells == 11);
p11.vertices(:,1:2) = p11.vertices(:,1:2)*voxelSize(1);
p11.vertices(:,3) = p11.vertices(:,3)*voxelSize(3);
patch(p11,'FaceColor',[180/255 67/255 59/255],'EdgeColor','none'); axis image; alpha(opac)

p12 = isosurface(output_cells == 12);
p12.vertices(:,1:2) = p12.vertices(:,1:2)*voxelSize(1);
p12.vertices(:,3) = p12.vertices(:,3)*voxelSize(3);
patch(p12,'FaceColor',[45/255 99/255 68/255],'EdgeColor','none'); axis image; alpha(opac)

p13 = isosurface(output_cells == 13);
p13.vertices(:,1:2) = p13.vertices(:,1:2)*voxelSize(1);
p13.vertices(:,3) = p13.vertices(:,3)*voxelSize(3);
patch(p13,'FaceColor',[180/255 67/255 59/255],'EdgeColor','none'); axis image; alpha(opac)

p14 = isosurface(output_cells == 14);
p14.vertices(:,1:2) = p14.vertices(:,1:2)*voxelSize(1);
p14.vertices(:,3) = p14.vertices(:,3)*voxelSize(3);
patch(p14,'FaceColor',[45/255 99/255 68/255],'EdgeColor','none'); axis image; alpha(opac)

p15 = isosurface(output_cells == 15);
p15.vertices(:,1:2) = p15.vertices(:,1:2)*voxelSize(1);
p15.vertices(:,3) = p15.vertices(:,3)*voxelSize(3);
patch(p15,'FaceColor',[45/255 99/255 68/255],'EdgeColor','none'); axis image; alpha(opac)

p16 = isosurface(output_cells == 16);
p16.vertices(:,1:2) = p16.vertices(:,1:2)*voxelSize(1);
p16.vertices(:,3) = p16.vertices(:,3)*voxelSize(3);
patch(p16,'FaceColor',[251/255 192/255 52/255],'EdgeColor','none'); axis image; alpha(opac)

view([165 -90]);  axis equal; axis vis3d; axis off;
%% %% Reconstruct egg chamber nuclei with colors in full 3D

p1 = isosurface(output_cells == 1);
p1.vertices(:,1:2) = p1.vertices(:,1:2)*voxelSize(1);
p1.vertices(:,3) = p1.vertices(:,3)*voxelSize(3);
patch(p1,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p2 = isosurface(output_cells == 2);
p2.vertices(:,1:2) = p2.vertices(:,1:2)*voxelSize(1);
p2.vertices(:,3) = p2.vertices(:,3)*voxelSize(3);
patch(p2,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p3 = isosurface(output_cells == 3);
p3.vertices(:,1:2) = p3.vertices(:,1:2)*voxelSize(1);
p3.vertices(:,3) = p3.vertices(:,3)*voxelSize(3);
patch(p3,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p4 = isosurface(output_cells == 4);
p4.vertices(:,1:2) = p4.vertices(:,1:2)*voxelSize(1);
p4.vertices(:,3) = p4.vertices(:,3)*voxelSize(3);
patch(p4,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p5 = isosurface(output_cells == 5);
p5.vertices(:,1:2) = p5.vertices(:,1:2)*voxelSize(1);
p5.vertices(:,3) = p5.vertices(:,3)*voxelSize(3);
patch(p5,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p6 = isosurface(output_cells == 6);
p6.vertices(:,1:2) = p6.vertices(:,1:2)*voxelSize(1);
p6.vertices(:,3) = p6.vertices(:,3)*voxelSize(3);
patch(p6,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p7 = isosurface(output_cells == 7);
p7.vertices(:,1:2) = p7.vertices(:,1:2)*voxelSize(1);
p7.vertices(:,3) = p7.vertices(:,3)*voxelSize(3);
patch(p7,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p8 = isosurface(output_cells == 8);
p8.vertices(:,1:2) = p8.vertices(:,1:2)*voxelSize(1);
p8.vertices(:,3) = p8.vertices(:,3)*voxelSize(3);
patch(p8,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p9 = isosurface(output_cells == 9);
p9.vertices(:,1:2) = p9.vertices(:,1:2)*voxelSize(1);
p9.vertices(:,3) = p9.vertices(:,3)*voxelSize(3);
patch(p9,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p10 = isosurface(output_cells == 10);
p10.vertices(:,1:2) = p10.vertices(:,1:2)*voxelSize(1);
p10.vertices(:,3) = p10.vertices(:,3)*voxelSize(3);
patch(p10,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p11 = isosurface(output_cells == 11);
p11.vertices(:,1:2) = p11.vertices(:,1:2)*voxelSize(1);
p11.vertices(:,3) = p11.vertices(:,3)*voxelSize(3);
patch(p11,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p12 = isosurface(output_cells == 12);
p12.vertices(:,1:2) = p12.vertices(:,1:2)*voxelSize(1);
p12.vertices(:,3) = p12.vertices(:,3)*voxelSize(3);
patch(p12,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p13 = isosurface(output_cells == 13);
p13.vertices(:,1:2) = p13.vertices(:,1:2)*voxelSize(1);
p13.vertices(:,3) = p13.vertices(:,3)*voxelSize(3);
patch(p13,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p14 = isosurface(output_cells == 14);
p14.vertices(:,1:2) = p14.vertices(:,1:2)*voxelSize(1);
p14.vertices(:,3) = p14.vertices(:,3)*voxelSize(3);
patch(p14,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p15 = isosurface(output_cells == 15);
p15.vertices(:,1:2) = p15.vertices(:,1:2)*voxelSize(1);
p15.vertices(:,3) = p15.vertices(:,3)*voxelSize(3);
patch(p15,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

p16 = isosurface(output_cells == 16);
p16.vertices(:,1:2) = p16.vertices(:,1:2)*voxelSize(1);
p16.vertices(:,3) = p16.vertices(:,3)*voxelSize(3);
patch(p16,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none'); axis image; alpha(0.2)

for i = 2:16
p1 = isosurface(nuclei.*(output_cells == i));
p1.vertices(:,1:2) = p1.vertices(:,1:2)*voxelSize(1);
p1.vertices(:,3) = p1.vertices(:,3)*voxelSize(3);
patch(p1,'FaceColor',[0.2 0.4 0.6],'EdgeColor','none'); axis image; alpha(0.2); hold on; 

p2 = isosurface(nucleoli.*(output_cells == i));
p2.vertices(:,1:2) = p2.vertices(:,1:2)*voxelSize(1);
p2.vertices(:,3) = p2.vertices(:,3)*voxelSize(3);
patch(p2,'FaceColor','r','EdgeColor','none'); axis image; alpha(0.4)
end

view([165 -90]);  axis equal; axis vis3d; axis off;