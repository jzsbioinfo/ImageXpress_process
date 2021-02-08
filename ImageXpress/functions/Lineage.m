
function Lineage = Lineage(Fission,t,cell_i)


%% 3. Find generation


%% calculate previous lineage index and age for each cell
age              = 0;
Lineage_age(t)   = age;
Lineage_index(t) = cell_i;

for T = t:-1:2 
    if Lineage_index(T) == 0 
           age  = - 1;
        Lineage_index(T-1)       = 0;
        Lineage_age(T-1)         = -1;
    else
        if sum( Fission(T).mother == Fission(T).mother(Lineage_index(T)) ) >1
            age = age - 1;
        end
        Lineage_index(T-1)       =  Fission(T).mother(Lineage_index(T));
        Lineage_age(T-1)         = age;
    end
end


Birth     = min(find(Lineage_age ==0)); % born timepoint
% Size_born = Fission(Birth).area(Lineage_index(Birth)).Area; 

age  = 0;
Type = 'unfinished';
% Size_before_division = 0;

for T = t:(length(Fission)-1)
    
    if sum(Fission(T+1).mother == Lineage_index(T))>1  % a mother has 2 daughter cells
%         Size_before_division   = Fission(T).area(Lineage_index(T)).Area; 
        Type = 'division';
        break;
    end
    
    if sum(Fission(T+1).mother==Lineage_index(T))==0
        Type = 'disappear';
        break;
    end
    Lineage_index(T+1) = find(Fission(T+1).mother==Lineage_index(T)) ;
    Lineage_age(T+1)   = age;
    
end

Lineage_age                  = Lineage_age'  ;
Lineage_index                = Lineage_index';

Lineage.Lineage_age          = Lineage_age;
Lineage.Lineage_index        = Lineage_index;
Lineage.Type                 = Type;
% Lineage.Size_before_division = Size_before_division;
% Lineage.Size_born            = Size_born;


