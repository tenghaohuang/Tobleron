function [frames_path] = video2frame(fileName,folderName)
%VIDEO2FRAME Summary of this function goes here
%   Detailed explanation goes here
a=VideoReader(fileName);

directName = folderName;
count = 0;
h_w = waitbar(0,{'Decomposing video into frames. If you think you can do'...
    'it faster, why don''t you try?'});

for img = 1:a.NumberOfFrames;
    
    waitbar(img/a.NumberOfFrames);
    filename=strcat('frame',num2str(img),'.jpg');
    b = read(a, img);
    imwrite(b,fullfile(directName,filename));
    
end

pause(1);
delete(h_w);
frames_path = directName;

end

