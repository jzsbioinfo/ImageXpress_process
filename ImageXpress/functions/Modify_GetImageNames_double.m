% change  '*_O_G_*.tiff' to '*_O_R_*.tiff'


function Files_RFP = Modify_GetImageNames_double(Name_case_ori,Path,Files_num, Image_Type)

%-----------------------------%
% Image_Type = '*_O_R_*.tiff';
% Files     = dir([Path Image_Type]);
% Name_case = [Name_case_ori Image_Type(2:end-6)];
% 
% Temp = Files;
% for i = 1 : length(Files)
%     s = regexp(Temp(i).name,'_');
%     Files(str2num(Temp(i).name((s(2)+1):(s(3)-1)))) = Temp(i);
% end
% 
% Files_GFP = Files;
%-----------------------------%

Name_case = [Name_case_ori Image_Type];
Name_case = ['*_' Name_case]
Files     = dir([Path Name_case]);

%Name_case = [Name_case_ori Image_Type(2:end-6)];

Temp = Files;
for i = 1 : length(Files)
    s = regexp(Temp(i).folder,'TimePoint');
    Files(str2num(Temp(i).folder((s(1)+10):end))) = Temp(i);     % ����������һ�£�����
end
Files = Files(Files_num);
Files_RFP = Files;
%-----------------------------%

