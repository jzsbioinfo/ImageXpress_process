function Sister_Pair = Yeastbow_Get_sisters(Fission,t,cell_i)
%%
% calculate lineage for each cell and its sister, calcuate angle and dist
% for each pair of sister cells
%%
Lineages = Lineage(Fission,t,cell_i);
Birth     = min(find(Lineages.Lineage_age ==0)); % born timepoint
Birth_Mother    = Fission(Birth).mother;
Sister          = setdiff(find(Birth_Mother  == Birth_Mother(Lineages.Lineage_index(Birth))),Lineages.Lineage_index(Birth));
Sister          = Sister(1);

Lineages_sister = Lineage(Fission,Birth,Sister);
Division        = min([max(find(Lineages.Lineage_age==0)) max(find(Lineages_sister.Lineage_age==0))]);

T = Birth:Division;
for i = 1:length(T)
    Sister_Pair(i).t = T(i);
    Sister_Pair(i).index = [Lineages.Lineage_index(T(i)) Lineages_sister.Lineage_index(T(i))]';
end
%%

T     = [Sister_Pair.t];
Cells = [Sister_Pair.index]';

for i = 1:length(Sister_Pair)
    
xy_a = Fission(T(i)).centroid(Cells(i,1)).Centroid;
xy_b = Fission(T(i)).centroid(Cells(i,2)).Centroid;
v_a  = [Fission(T(i)).Ends(Cells(i,1)).Ends - Fission(T(i)).Heads(Cells(i,1)).Heads ];
v_b  = [Fission(T(i)).Ends(Cells(i,2)).Ends - Fission(T(i)).Heads(Cells(i,2)).Heads ];
CosTheta       = dot(v_a,v_b)/(norm(v_a)*norm(v_b));
ThetaInDegrees = acosd(CosTheta);

Sister_Pair(i).dist = dist(xy_a,xy_b');
Sister_Pair(i).angle = ThetaInDegrees;
end
