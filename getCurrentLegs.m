function ret = getCurrentLegs(data,fNum,ct)

begin =0;
for i=1:size(data,1)
    if(data(i,1)==fNum & data(i,2)==ct)
        begin = i;
        break;
    end
end
data(begin,:)=[]
data(begin,:)=[]
ret = data