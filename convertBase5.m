%convertBase5.m
function converted=convertBase5(valInput)
reste=valInput;
for j=4:-1:0
    converted(j+1)=floor(reste/5^j)+1;
    reste=reste-(converted(j+1)-1)*5^j;
end