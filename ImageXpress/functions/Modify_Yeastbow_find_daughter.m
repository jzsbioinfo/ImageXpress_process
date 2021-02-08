function Fission = Modify_Yeastbow_find_daughter(Fission)
%% lineage tracing, cell in last image has no dughter



for j=1:length(Fission(length(Fission)).centroid)
    Fission(length(Fission)).daughter(j) = 0;
end
    
%% daugter is defined in next position, present centriod in next area

for i = 1:(length(Fission)-1)
    for j=1:length(Fission(i).centroid)
    Point = Fission(i).centroid(j).Centroid;
    Index = Find_points(Point,Fission(i+1).ROIs);
    
    if isempty(Index) % failed to find daughter cell
%         xy_mothers = [];
%         for s=1:length([Fission(i-1).centroid])
%             xy_mothers = [xy_mothers;Fission(i-1).centroid(s).Centroid];
%         end
        Index = 0;
%       [~, Index] = min( dist(Point,xy_mothers') );
    end
    
    Fission(i).daughter(j) = Index(1);
    end
end

end