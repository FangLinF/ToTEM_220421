function sernum = fanyi(str);
xx = findstr(str,' ');
str(xx)=',';   % replace space by , 
xuhao1 = findstr(str,'(');
xuhao2 = findstr(str,')');
if length(xuhao1) ~= length(xuhao2)  %if the number of ( is not equal to ), wrong
    sernum = [];
    return;
end

if isempty(xuhao1)
    sernum = str2num(str);
    return;
end
if xuhao1(1)==1  %if the 1st str is (,delete this pair
   newstr = str;
   newstr(xuhao2(1)) = [];
   newstr(xuhao1(1)) = [];
else
    newstr=str;
end

xuhao1 = findstr(str,'(');
xuhao2 = findstr(str,')');
for i1=length(xuhao1):-1:1; %to find each pairs of ()
    if newstr(xuhao1(i1)-1) == ',' || newstr(xuhao1(i1)-1) == ' '  % if it is a ',', or ' '
       newstr(xuhao2(i1)) = [];
       newstr(xuhao1(i1)) = [];
    end
    ind=1;
    while xuhao1(i1)-ind>1 & isstrprop(newstr(xuhao1(i1)-ind),'digit')
        ind=ind+1;
    end
    ind=ind-1;
    tempnum = str2num(newstr(xuhao1(i1)-ind :xuhao1(i1)-1));
    
    tempstr = newstr(xuhao1(i1)+1 : xuhao2(i1)-1);  % repeat unit such as 2(1:3)
    for i=1:tempnum % repeat several times to built the array
        if i==1
           repstr = tempstr;
           repstr(end+1)=',';
        else
            repstr(end+1:end+length(tempstr))=tempstr;
            repstr(end+1)=',';
        end
    end    
    
    tempstrbeg = newstr(1:xuhao1(i1)-ind-1);  %把头端复制了
    tempstrend = newstr(xuhao2(i1)+1:end);  %把尾端复制了
    newstr = strcat(tempstrbeg, repstr(1:end-1), tempstrend);
    
end
sernum = str2num(newstr);
pp=1;