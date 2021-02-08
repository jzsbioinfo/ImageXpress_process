
function Fission = Yeaastbow_age(Fission)

for t = 1
    for cell_i = 1:length(Fission(t).centroid)
        Fission(t).Heads(cell_i).age = 0;
        Fission(t).Ends(cell_i).age  = 0;
    end
end

for t = 2:length(Fission)
    for cell_i = 1:length(Fission(t).centroid)
        mother        = Fission(t).mother(cell_i);
        mother_head   = Fission(t-1).Heads(mother).Heads;
        mother_end    = Fission(t-1).Ends(mother).Ends;
        daughter_head = Fission(t).Heads(cell_i).Heads;
        daughter_end  = Fission(t).Ends(cell_i).Ends;
        
        
        if sum(Fission(t).mother == mother)>1 % division
            
                %% mother head as origin
           if min([dist(mother_head',daughter_end) dist(mother_head',daughter_head)]) < min([dist(mother_end',daughter_end) dist(mother_end',daughter_head)])
                Fission(t).Heads(cell_i).age   = 0;
                Fission(t).Ends(cell_i).age    = Fission(t-1).Heads(mother).age+1;
           if dist(mother_head',daughter_end)>dist(mother_head',daughter_head)
                Fission(t).Heads(cell_i).Heads = daughter_end;
                Fission(t).Ends(cell_i).Ends   = daughter_head; 
           end
           
           else     %% mother end as origin
               
                Fission(t).Heads(cell_i).age   = 0;
                Fission(t).Ends(cell_i).age    = Fission(t-1).Ends(mother).age+1;
            if dist(mother_end',daughter_end)>dist(mother_end',daughter_head)
                Fission(t).Heads(cell_i).Heads = daughter_end;
                Fission(t).Ends(cell_i).Ends   = daughter_head;
            end
                
           end

            
        else
            Fission(t).Heads(cell_i).age   = Fission(t-1).Heads(mother).age;
            Fission(t).Ends(cell_i).age    = Fission(t-1).Ends(mother).age;
            if dist(mother_end',daughter_end)>dist(mother_end',daughter_head)
                Fission(t).Heads(cell_i).Heads = daughter_end;
                Fission(t).Ends(cell_i).Ends   = daughter_head;
            end
        end
        
    end
    
end