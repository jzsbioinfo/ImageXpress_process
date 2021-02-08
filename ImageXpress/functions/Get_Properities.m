
% i  =  1;
% T          = Division_Events(i).Life2;
% cell_index = Division_Events(i).Lineage2;

% properity = 'area'

function Temp = Get_Properities(T,cell_index,properity,Fission)

Temp = [];

if ~isnan(T)
for i = 1:length(T)
    if cell_index(i)==0
        eval( ['Temp = [Temp;Fission(1).' properity '(1)];']);
    else 
        eval( ['Temp = [Temp;Fission(T(' num2str(i) ')).' properity '(cell_index(' num2str(i) '))];']);
    end
end

Temp = struct2array(Temp);

for i = 1:length(T)
    if cell_index(i)==0
Temp(i) = 0;   
    end
end


end
    


