function resul_pos = randshiftpos(ini_pos, eachthick, slicethick, mid_slice_num);
rng('shuffle');
resul_pos =  ini_pos;
randpos=randn(length(ini_pos(:,1)),3).*repmat(sqrt(ini_pos(:,5)/8/pi/pi),1,3);   %�������ı仯��
resul_pos(:,2:4)=randpos+ini_pos(:,2:4);  %����µ�������֮꣬��ʹ��allnuclear_copy���м���  %������3��������񶯣������������������Ҫ�۵�sqrt(3)�Ĳ��� 20210103
%resul_pos(:,2:3)=randpos(:,1:2)+ini_pos(:,2:3);
while length( find(resul_pos(:,4)<slicethick(1) | resul_pos(:,4)>=slicethick(end)+eachthick) ) >0  
    %if any atom shift to the boundaries of crystal, its position will be
    %random again
    i = find((resul_pos(:,4)<slicethick(1) | resul_pos(:,4)>=slicethick(end)+eachthick));
    randpos=randn(length(i),3).*repmat(sqrt(ini_pos(i,5)/8/pi/pi),1,3);
    resul_pos(i,2:4)=randpos+ini_pos(i,2:4);
    %resul_pos(i,2:3)=randpos(:,1:2)+ini_pos(i,2:3);
end

if ~isempty(mid_slice_num)
    %atoms must be within their special slices
    for j = 1 : length(mid_slice_num)
        %ȷ��λ���Ĳ��ڵ�ԭ�ӣ��񶯺���Ȼλ���Ĳ�
        
        %�ҵ���Щԭ������ǰ������midslice���ڵ�
        k = find( ini_pos(:,4) < slicethick(mid_slice_num(j)) + eachthick ); % find atoms that within the mid_slice_num thickness
        %for example, 10 12 14 15 atoms should be within mid_slice_num
        
        %�ҵ���Щԭ�����񶯺�������midslice���ڵ�
        kk = find( resul_pos(:,4) < slicethick(mid_slice_num(j)) + eachthick );
        %for example after shift, 10 12 15 17 atoms are within mid_slice_num
        
        while ~isequaltwo( k, kk)  %��ǰ��Ӧ��һ��
            [kandkk, ik, ikk]= intersect(k,kk);   %k��kk�Ľ���
            % for example, 10, 12, 15 will be the intersection
            
            somekk = setdiff(kk,kandkk);   %�ҵ���Щ�񶯳����ԭ�ӵ����,�ҵ�����
            % for example, 17 means that the 17th atoms should be shifted
            somek  = setdiff(k, kandkk);   %�ҵ���Щ�񶯳����ԭ�ӵ����,�ҵ�����
            % for example, 14 means that the 14th atoms should be shifted
            
            randpos=randn(length([somek; somekk]),3).*repmat(sqrt(ini_pos([somek; somekk],5)/8/pi/pi),1,3);
            resul_pos([somek; somekk],2:4) = randpos+ini_pos([somek; somekk],2:4);
            %resul_pos([somek; somekk],2:3) = randpos(:,1:2)+ini_pos([somek; somekk],2:3);
            kk = find( resul_pos(:,4) < slicethick(mid_slice_num(j)) + eachthick );
        end
    end
end
%output the number of atoms before and after vibration
%������Щ���ڣ��ֱ��ж��ٸ�ԭ�ӣ��񶯺��
num = unique([mid_slice_num,length(slicethick)]);
for i = 1: length(num)
    %��Щԭ��λ�ڵ�kk�㣻
    disp(strcat('After vibration, in selected region, within the ', num2str(num(i)), 'th slice, there are '));
    
    kk = find( resul_pos(:,4) >= slicethick(1) & resul_pos(:,4) < slicethick(num(i))+eachthick );

    allelement = unique( resul_pos(kk,1) );  %�ҵ��ж�����ԭ��
    for j= 1 : length(allelement)
        elementnum = length ( find( resul_pos(kk,1) == allelement(j)));
        disp(strcat(' Element ', num2str(allelement(j)), ':', num2str(elementnum)));
    end
    
    
    
    disp(strcat('Before vibration, within the ', num2str(num(i)), 'th slice, there are '));
    
    kk = find( ini_pos(:,4) >= slicethick(1) & ini_pos(:,4) < slicethick(num(i))+eachthick );

    allelement = unique( resul_pos(kk,1) );  %�ҵ��ж�����ԭ��
    for j= 1 : length(allelement)
        elementnum = length ( find( ini_pos(kk,1) == allelement(j)));
        disp(strcat(' Element ', num2str(allelement(j)), ':', num2str(elementnum)));
    end
end
return;

function flag = isequaltwo( k, kk)  %�ж����������Ƿ���ȫһ�� find whether two vectors are the same; 
%same flag=1; different flag=0
if length(k)~=length(kk)  %��������һ��
    flag = 0;
    return;
else
    if sum( k == kk) == length(k)  %��������һ��
        flag = 1;
    else
        flag = 0;  %��������һ��
    end
end
    
    