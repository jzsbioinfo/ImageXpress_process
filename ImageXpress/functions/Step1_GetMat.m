addpath('Functions/');

clc; clear;
% Name = '20190711_6'
Name = 'Data1_control';
% Name = 'Data2_control';
% Name = 'Data3_resting';
% Name = 'Data4_resting';

Image = imreadstack(['Data/' Name '.tif'],1:1000); % read tif images

%% 1. Find each mother
for i=1:size(Image,3)
        BW                = im2bw(Image(:,:,i));   % convert images to 0-1 mask
        BW = imfill(BW,'holes');

%     BW                          = Image(:,:,i)>0;   % convert images to 0-1 mask
    Fission(i).ROIs             = regionprops(BW, 'ConvexHull');  % find boundary for each cell
    Fission(i).Orient           = regionprops(BW, 'Orientation'); % find angle for each cell
    Fission(i).centroid         = regionprops(BW, 'centroid');        % find position for each cell
    Fission(i).area             = regionprops(BW, 'area');        % find position for each cell
    Fission(i).MajorAxisLength  = regionprops(BW, 'MajorAxisLength');        % find position for each cell
    Fission(i).MinorAxisLength  = regionprops(BW, 'MinorAxisLength');        % find position for each cell
    Fission(i).Eccentricity     = regionprops(BW, 'Eccentricity');
    Fission(i).BW               = bwlabeln(BW);                      % label each cell with its index
    Fission(i).itself           = 1:length(Fission(i).area );        % index
end

%% 2. Find each mother
Fission        = Yeastbow_find_mother(Fission);

%% 3. calculate angle and head, end, up, down points
Fission         = Yeastbow_PCA_angle(Fission);

%% 4. calculate age for each head and end
Fission         = Yeaastbow_age(Fission);

for t =1:length(Fission)
    for cell_i = 1:length(Fission(t).Orient) 
                Fission(t).Heads_age(cell_i).age   = Fission(t).Heads(cell_i).age;
                Fission(t).Ends_age(cell_i).age    = Fission(t).Ends(cell_i).age;
    end
end
%% 5. find all division events
Division_Events = Yeastbow_All_division_events(Fission);


%% 6. Get lineage tree

for i=1:length(Division_Events)
    
    t = Division_Events(i).t;
    
    cell_i   = Division_Events(i).sister;
    Lineage1 = Lineage(Fission,t,cell_i(1));
    Lineage2 = Lineage(Fission,t,cell_i(2));
    Division_Events(i).mother = Fission(t).mother(cell_i(1));    
    
    Division_Events(i).index_last = [Lineage1.Lineage_index(end) Lineage2.Lineage_index(end)];
    Division_Events(i).t_last     = t+[Division_Events(i).LifeSpan];
    Division_Events(i).t_last([Division_Events(i).LifeSpan]==0)=nan;
    Division_Events(i).Tree = 0;
    Division_Events(i).Tree_age = 0;
    
    Division_Events(i).Lineage1 = Lineage1.Lineage_index(Lineage1.Lineage_age==0);
    Division_Events(i).Life1    = t:(Division_Events(i).t_last(1)-1);

    Division_Events(i).Lineage2 = Lineage2.Lineage_index(Lineage2.Lineage_age==0);
    Division_Events(i).Life2    = t:(Division_Events(i).t_last(2)-1);
    
    %%  get division angle and distance
    Sister_Pair = Yeastbow_Get_sisters(Fission,t,cell_i(1));
    Division_Events(i).Mean_angle = mean([Sister_Pair.angle]);
    Division_Events(i).Mean_dist  = mean([Sister_Pair.dist]);
    Division_Events(i).angle      = [Sister_Pair.angle];
    Division_Events(i).dist       = [Sister_Pair.dist];
    Division_Events(i).type       = mean([Sister_Pair.angle])<90;
    
end


for i=1:length(Division_Events)
    t1 = Division_Events(i).t_last(1);
    t2 = Division_Events(i).t_last(2);
    mother1 = Division_Events(i).index_last(1);
    mother2 = Division_Events(i).index_last(2);
    
    index1 = find(([Division_Events.t]==t1)&([Division_Events.mother]==mother1));
    index2 = find(([Division_Events.t]==t2)&([Division_Events.mother]==mother2));
    
    if ~isempty(index1)
        Division_Events(index1).Tree = i;
        Division_Events(index1).Tree_age = Division_Events(i).Tree_age+1;
    end
    if ~isempty(index2)
        Division_Events(index2).Tree = i;
        Division_Events(index2).Tree_age = Division_Events(i).Tree_age+1;
    end
end


%% 7. Get Area and length and width

for i=1:length(Division_Events)
    
    Division_Events(i).area1 = Get_Properities(Division_Events(i).Life1,Division_Events(i).Lineage1,'area',Fission);
    Division_Events(i).area2 = Get_Properities(Division_Events(i).Life2,Division_Events(i).Lineage2,'area',Fission);

    Division_Events(i).length1 = Get_Properities(Division_Events(i).Life1,Division_Events(i).Lineage1,'MajorAxisLength',Fission);
    Division_Events(i).length2 = Get_Properities(Division_Events(i).Life2,Division_Events(i).Lineage2,'MajorAxisLength',Fission);

    Division_Events(i).width1 = Get_Properities(Division_Events(i).Life1,Division_Events(i).Lineage1,'MinorAxisLength',Fission);
    Division_Events(i).width2 = Get_Properities(Division_Events(i).Life2,Division_Events(i).Lineage2,'MinorAxisLength',Fission);
    
    Division_Events(i).Heads_age1 = Get_Properities(Division_Events(i).Life1,Division_Events(i).Lineage1,'Heads_age',Fission);
    Division_Events(i).Heads_age2 = Get_Properities(Division_Events(i).Life2,Division_Events(i).Lineage2,'Heads_age',Fission);
    
    Division_Events(i).Ends_age1 = Get_Properities(Division_Events(i).Life1,Division_Events(i).Lineage1,'Ends_age',Fission);
    Division_Events(i).Ends_age2 = Get_Properities(Division_Events(i).Life2,Division_Events(i).Lineage2,'Ends_age',Fission);
    
end



%% 6. save mat
save(['Data/' Name '.mat']);

