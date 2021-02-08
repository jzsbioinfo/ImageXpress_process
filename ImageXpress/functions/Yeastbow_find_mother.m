function Fission = Yeastbow_find_mother(Fission)
%% lineage tracing, cell in first image has no mother
for j=1:length(Fission(1).centroid)
    Fission(1).mother(j) = 1;
end
    
%% mother is defined in previous position

for i = 2:length(Fission)
    for j=1:length(Fission(i).centroid)
    Point = Fission(i).centroid(j).Centroid;
    Index = Find_points(Point,Fission(i-1).ROIs);
    
    if isempty(Index) % failed to find mother cell
%         xy_mothers = [];
%         for s=1:length([Fission(i-1).centroid])
%             xy_mothers = [xy_mothers;Fission(i-1).centroid(s).Centroid];
%         end
        Index = 0;
%       [~, Index] = min( dist(Point,xy_mothers') );
    end
    
    Fission(i).mother(j) = Index(1);
    end
end

end