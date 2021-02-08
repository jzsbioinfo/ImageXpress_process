function Division_Events = Yeastbow_All_division_events(Fission)

%% find all division evens in the whole movie

j = 0;
for i=2:length(Fission)
    if length(Fission(i).mother)~=length(Fission(i-1).mother)
        for m = Fission(i-1).itself
            % i is time
            % m is mother index
            % I are sisters
            I = Fission(i).mother==m;
            if sum(I)>1
                j=j+1;
                Division_Events(j).t = i;
                Division_Events(j).sister = Fission(i).itself(I);
                Lineages1   =  Lineage(Fission,Division_Events(j).t,Division_Events(j).sister(1));
                
                if strcmp(Lineages1.Type,'division')
                    LifeSpan1  =  sum(Lineages1.Lineage_age==0);
                else
                    LifeSpan1  = 0;
                end
                
                Lineages2   =  Lineage(Fission,Division_Events(j).t,Division_Events(j).sister(2));
                if strcmp(Lineages2.Type,'division')
                    LifeSpan2  =  sum(Lineages2.Lineage_age==0);
                else
                    LifeSpan2  = 0;
                end
                
                Division_Events(j).LifeSpan  = [LifeSpan1 LifeSpan2]; 
                Division_Events(j).Size_divd = [Lineages1.Size_before_division Lineages2.Size_before_division];
                Division_Events(j).Size_born = [Lineages1.Size_born Lineages2.Size_born];
                
            end
        end
    end
end

%                             sss   =  Lineage(Fission,10,1);
    
                
                

