function [corr_ele_n, corr_ele_n_i, corr_info, series_n_corr, series_n_i_corr] = ...    %������һ����������ʾ���䲨��Ҫ�߶೤����գ����ﹲͬ�ض��ĵײ�
            CalAllEquilent20210305_peng_corr(corr_nuclear_copy, corr_peng_nuc_ion_copy, eachthick, slicethick, multiceng);   
discon=0.006; %0.015;  %��������²�ľ�����discon���ڣ��ͷ�2�㣬����Ǵ������ֵ������1����
        %   ���������Ƴ���������ԭ��λ�÷�����
%   ֱ�Ӹ��ݲ�ĺ�������Լ�ԭ�ӵ����꣬�����֣�
%   ����ʱ�������2��
%   corr_nuclear_copy, corr_peng_nuc_ion_copy����������࣬ԭ�����꣬������
%   slicethickΪ0 0.2 0.4 0.6 0.8�������Ʒ�Ǵ�0-1.0�ĺ�ȵĻ�
%20201102�޸ĳ��µķ�ʽ��������������Ĺ�ʽ���ѵȼ�ԭ��λ���ҵ������Ҹ���a��b��ϵ�����Լ��ض�ԭ�ӵľ���
%ϵ�����cuda����Լ�matlab���    ������

%����ʹ�õ��Ǻ�lobatoһ���Ĵ����������Ժ������ԭ����
% % % %DBmode�Ǽ���Debye�ķ�ʽ��ֻ���lobato�Ĳ�����������Ϊlobato�Ĳ����ڲ�ѡ��DW˥����absorptive��ʱ�򣬼���ֻ��frozenʱ��B������0��
% % % %DBmode�����0,����frozen��ʽ�������1������DB˥������



%����������ԭ�ӵ���Ϣ����ע��ele_n��doc����۵���ɫ����Щ��series��ʾÿ��������ٸ�ԭ�ӣ�
corr_ele_n=[]; corr_ele_n_i=[]; 
series_n_corr=[]; series_n_i_corr=[];%ÿ������˶��ٵ�ԭ��
%����
% load randpos8
% corr_nuclear_copy(:,2:4)=corr_nuclear_copy(:,2:4)+randpos8*0.7;

if ~isempty(corr_nuclear_copy)
    [a, b, c] = unique(corr_nuclear_copy(:,7:26),'rows');  %���ص�a��b��a�ǲ��ظ���ϵ����c�ǹ��������
    
    corr_info = a ;  %��Ԫ�ص���Ϣ������
    corr_nuclear_copy(:,7)=c;
    corr_nuclear_copy(:,8:end)=[];   %�ѵڰ���֮��Ķ�ɾ��
    
    for i=1:length(slicethick)
        jj = find(corr_nuclear_copy(:,4) >= slicethick(i) & corr_nuclear_copy(:,4) < slicethick(i)+eachthick);  %�ҵ��������Ҫ���ԭ�����
        templen = length(jj);  %��¼�ж��ٸ�ԭ��λ����һ����
        corr_ele_n(end+1:end+length(jj),1:11) = [corr_nuclear_copy(jj,:).';... %7��Ԫ��
            1.0.*ones(1,templen);...%�����Ȩ��
            i.*ones(1,templen); ...%λ���ĸ�ԭ�Ӳ���
            corr_nuclear_copy(jj,4).'.*ones(1,templen) - slicethick(i);...%�����ϱ���ľ���
            corr_nuclear_copy(jj,4).'.*ones(1,templen) - slicethick(i)-eachthick].';  %�����±���ľ���
    end
    if eachthick > 2*discon & multiceng>=1 %���Ҫ��ֲ㣻�ң����������2����discon���ͽ��Ž�ԭ���������зֲ㣻�����п��ܻ����2��������������
        %���ԭ�Ӿ����ϱ���С��discon���ң�����λ�ڵ�1�㣬�ͷ�һ�������
        jj =  find( corr_ele_n(:,end-1) < discon & corr_ele_n(:,end-2) >1 );
        %���ԭ�Ӿ����±������-discon���ң�����λ�����㣬�ͷ�һ�������
        jjjj =  find( corr_ele_n(:,end) > -discon & corr_ele_n(:,end-2) <length(slicethick) );
        
        if ~isempty(jj)
            corr_ele_n(jj,8) = 0.5; %��һ������             
            corr_ele_n(end+1:end+length(jj),:) = corr_ele_n(jj,:); %������
            corr_ele_n(end:-1:end-length(jj)+1,end-2) = corr_ele_n(end:-1:end-length(jj)+1,end-2)-1;  %��ż�1
        end
        
        if ~isempty(jjjj)
            corr_ele_n(jjjj,8) = 0.5; %��һ������
            corr_ele_n(end+1:end+length(jjjj),:) = corr_ele_n(jjjj,:); %������
            corr_ele_n(end:-1:end-length(jjjj)+1,end-2) = corr_ele_n(end:-1:end-length(jjjj)+1,end-2)+1;  %��ż�1
        end
    end
    corr_ele_n(:,end-1:end) = [];  %ȥ���������±������Ϣ %��ʣ��9��Ԫ��
    [a,c] = sort(corr_ele_n(:,end)); %�������Ĳ���Ϣ����������
    corr_ele_n = corr_ele_n(c,:);
    
    for i=1:length(slicethick)
        series_n_corr(i) = length( find(corr_ele_n(:,end)==i));  %�ҵ�ÿ��������ٸ�ԭ��
    end
    
        %����ȥ���������Ϣ
    corr_ele_n(:,6) = corr_ele_n(:,6).*corr_ele_n(:,8);
    corr_ele_n(:,[9,8,4,1])=[];
end


%�ⲿ��û�������Ƿ���ȷ�����������Ժ�ԭ���Զ���
if ~isempty(corr_peng_nuc_ion_copy)
    [a, b, c] = unique(corr_peng_nuc_ion_copy(:,8:27),'rows');  %���ص�a��b��a�ǲ��ظ���ϵ����c�ǹ��������   
    corr_info = a ;  %��Ԫ�ص���Ϣ������  
    kindnum = length(corr_info(:,1)); %�ܹ��ж�����
    corr_peng_nuc_ion_copy(:,8)=c;
    
    [a, b, c] = unique(corr_peng_nuc_ion_copy(:,29:48),'rows');  %���ص�a��b��a�ǲ��ظ���ϵ����c�ǹ��������   
    %corr_info_n_i = a ;  %��Ԫ�ص���Ϣ������ 
    corr_info(end+1:end+length(a(:,1)),:) = a+kindnum;  %ÿ�������+ԭ�������Ե����
    corr_peng_nuc_ion_copy(:,29)=c+kindnum;  %�ҵ���Ӧ���������
    
    corr_peng_nuc_ion_copy(:,30:end)=[];   %�ѵ�16��֮��Ķ�ɾ��
    corr_peng_nuc_ion_copy(:,9:27)=[];   %�ѵ�9��֮��Ķ�ɾ��  ֻ����ԭ����28���������Ա�������29�и�ֵ���������
    
    for i=1:length(slicethick)
        jj = find(corr_peng_nuc_ion_copy(:,4) >= slicethick(i) & corr_peng_nuc_ion_copy(:,4) < slicethick(i)+eachthick);  %�ҵ��������Ҫ���ԭ�����
        templen = length(jj);  %��¼�ж��ٸ�ԭ��λ����һ����
        corr_ele_n_i(end+1:end+length(jj),1:14) = [corr_peng_nuc_ion_copy(jj,:).';... %10��Ԫ��
            1.0.*ones(1,templen);...%�����Ȩ��
            i.*ones(1,templen); ...%λ���ĸ�ԭ�Ӳ���
            corr_peng_nuc_ion_copy(jj,4).'.*ones(1,templen) - slicethick(i);...%�����ϱ���ľ���
            corr_peng_nuc_ion_copy(jj,4).'.*ones(1,templen) - slicethick(i)-eachthick].';  %�����±���ľ���
    end
    if eachthick > 2*discon  & multiceng>=1 %���Ҫ��ֲ㣬�ң����������2����discon���ͽ��Ž�ԭ���������зֲ㣻�����п��ܻ����2��������������
        %���ԭ�Ӿ����ϱ���С��discon���ң�����λ�ڵ�1�㣬�ͷ�һ�������
        jj =  find( corr_peng_nuc_ion_copy(:,end-1) < discon & corr_peng_nuc_ion_copy(:,end-2) >1 );
        %���ԭ�Ӿ����±������-discon���ң�����λ�����㣬�ͷ�һ�������
        jjjj =  find( corr_peng_nuc_ion_copy(:,end) > -discon & corr_peng_nuc_ion_copy(:,end-2) <length(slicethick) );
        
        if ~isempty(jj)
            corr_ele_n_i(jj,11) = 0.5; %��һ������             
            corr_ele_n_i(end+1:end+length(jj),:) = corr_ele_n_i(jj,:); %������
            corr_ele_n_i(end:-1:end-length(jj)+1,end-2) = corr_ele_n_i(end:-1:end-length(jj)+1,end-2)-1;  %��ż�1
        end
        
        if ~isempty(jjjj)
            corr_ele_n_i(jjjj,11) = 0.5; %��һ������
            corr_ele_n_i(end+1:end+length(jjjj),:) = corr_ele_n_i(jjjj,:); %������
            corr_ele_n_i(end:-1:end-length(jjjj)+1,end-2) = corr_ele_n_i(end:-1:end-length(jjjj)+1,end-2)+1;  %��ż�1
        end
        
    end
    %corr_ele_n_i(:,end-1:end) = [];  %ȥ���������±������Ϣ %��ʣ��12��Ԫ��
    [a,c] = sort(corr_ele_n_i(:,end)); %�������Ĳ���Ϣ����������
    corr_ele_n_i = corr_ele_n_i(c,:);
    
      
    for i=1:length(slicethick)
        series_n_i_corr(i) = length( find(corr_ele_n_i(:,end)==i)); 
    end
    
    %����ȥ���������Ϣ
    corr_ele_n_i(:,6) = corr_ele_n_i(:,6).*corr_ele_n_i(:,11);  %ռ����
    corr_ele_n_i(:,[12,11,4,1])=[];  %���²�ľ��룬ʵ�ʸ߶ȣ�������
end

   

pp=1;




        
function mypercent = project_poten_contribute(B, thick1, thick2);  %��˹������A��B���Լ���˹�������ֵķ�Χ
% if thick2==inf   %��ĳ���߶ȵ������Ļ��֡�������Եĺ��������DOC
%     mypercent=0.5* erfc(pi*thick1./sqrt(B));
% else
% %   ---------- thick1
% % 
% %       o atom sympble
% %  ----------- thick1+eachthick   ����ԭ�ӵ��϶��ľ��룻���µ׵ľ������zheight_2
%     mypercent =0.5* erf(pi*thick1./sqrt(B)) + 0.5* erf(pi*thick2./sqrt(B));  %�������ڵ�ǿ�Ƚ��е���
% end
%  ������ϱ�����±����㹻Զ�������Ϊ1�����⣬0.5����ȥ������Ϊerf�������Ա�������ܴ��ǵ���1��Ҳ���ǣ�Ĭ��ż���������Ŵ�
% ���������������±���Ļ��ֵ���ֵ����һ����

    mypercent=abs(0.5* erf(2*pi*thick2(:)./sqrt(B(:))) - 0.5* erf(2*pi*thick1(:)./sqrt(B(:)))) ;


