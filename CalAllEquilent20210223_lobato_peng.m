function [ele_n, ele_n_i, newabsorp_n, newabsorp_n_i,series_n, series_n_i] = ...    %������һ����������ʾ���䲨��Ҫ�߶೤����գ����ﹲͬ�ض��ĵײ�
            CalAllEquilent20210223_lotabo_peng(all_n, all_n_i, absorp_n, absorp_n_i, eachthick, slicethick, multiceng, paraflag, DBmode);  
%   ֱ�Ӹ��ݲ�ĺ�������Լ�ԭ�ӵ����꣬�����֣�
%   ����ʱ��multiceng��ʾ����Ӱ����ٲ㣬һ����2*M+1��
%   all_n�Ĳ�����
%   slicethickΪ0 0.2 0.4 0.6 0.8�������Ʒ�Ǵ�0-1.0�ĺ�ȵĻ�
%20201102�޸ĳ��µķ�ʽ��������������Ĺ�ʽ���ѵȼ�ԭ��λ���ҵ������Ҹ���a��b��ϵ�����Լ��ض�ԭ�ӵľ���
%ϵ�����cuda����Լ�matlab���    ������

%DBmode�Ǽ���Debye�ķ�ʽ��ֻ���lobato�Ĳ�����������Ϊlobato�Ĳ����ڲ�ѡ��DW˥����absorptive��ʱ�򣬼���ֻ��frozenʱ��B������0��
%DBmode�����0,����frozen��ʽ�������1������DB˥������



%����������ԭ�ӵ���Ϣ����ע��ele_n��doc����۵���ɫ����Щ��series��ʾÿ��������ٸ�ԭ�ӣ�
series_n=[]; series_n_i=[]; %ÿ������˶��ٵ�ԭ��
ele_n=[]; ele_n_i=[]; 
newabsorp_n=[]; newabsorp_n_i=[];
%����
% load randpos8
% all_n(:,2:4)=all_n(:,2:4)+randpos8*0.7;

if ~isempty(all_n)
    for i=1:length(slicethick)
        jj = find(all_n(:,4) >= slicethick(i)-multiceng*eachthick & all_n(:,4) < slicethick(i)+multiceng*eachthick+eachthick);  %�ҵ��������Ҫ���ԭ�����
        series_n(i) = length(jj);  %��¼�ж��ٸ�ԭ��λ����һ����
        ele_n(end+1:end+length(jj),1:16) = all_n(jj,:);
        
         %��������10.bʽ��
        z1(1:length(jj),1) = ele_n(end-series_n(i)+1:end, 4) -(slicethick(i)+eachthick);
        z2(1:length(jj),1) = ele_n(end-series_n(i)+1:end, 4) - slicethick(i);
        if i==1
            z2(:)=inf;
        end
        if i==length(slicethick)
            z1(:)=-inf;  
        end
        z2(find(abs(z2)>=multiceng*eachthick)) = inf;
        z1(find(abs(z1)>=multiceng*eachthick)) = -inf;
        ele_n(end-series_n(i)+1:end, 17) = project_poten_contribute(ele_n(end-series_n(i)+1:end,8),  z1, z2);
        ele_n(end-series_n(i)+1:end, 18) = project_poten_contribute(ele_n(end-series_n(i)+1:end,10),  z1, z2);
        ele_n(end-series_n(i)+1:end, 19) = project_poten_contribute(ele_n(end-series_n(i)+1:end,12),  z1, z2);
        ele_n(end-series_n(i)+1:end, 20) = project_poten_contribute(ele_n(end-series_n(i)+1:end,14),  z1, z2);
        ele_n(end-series_n(i)+1:end, 21) = project_poten_contribute(ele_n(end-series_n(i)+1:end,16),  z1, z2);
        
        
        if ~isempty(absorp_n)  %����Ƿ�Ҫ��������
            newabsorp_n(end+1:end+length(jj),1:10) = absorp_n(jj,:);
            newabsorp_n(end-series_n(i)+1:end, 11) = project_poten_contribute(newabsorp_n(end-series_n(i)+1:end,2),  z1, z2);
            newabsorp_n(end-series_n(i)+1:end, 12) = project_poten_contribute(newabsorp_n(end-series_n(i)+1:end,4),  z1, z2);
            newabsorp_n(end-series_n(i)+1:end, 13) = project_poten_contribute(newabsorp_n(end-series_n(i)+1:end,6),  z1, z2);
            newabsorp_n(end-series_n(i)+1:end, 14) = project_poten_contribute(newabsorp_n(end-series_n(i)+1:end,8),  z1, z2);
            newabsorp_n(end-series_n(i)+1:end, 15) = project_poten_contribute(newabsorp_n(end-series_n(i)+1:end,10),  z1, z2);
        end
        z1=[];  %��Ҫ���㣬�������ݿ��ܻᴮ
        z2=[];
    end
    %��֮�󣬰���Ҫ�����
    ele_n(:,7)=ele_n(:,7).*ele_n(:,17);
    ele_n(:,9)=ele_n(:,9).*ele_n(:,18);
    ele_n(:,11)=ele_n(:,11).*ele_n(:,19);
    ele_n(:,13)=ele_n(:,13).*ele_n(:,20);
    ele_n(:,15)=ele_n(:,15).*ele_n(:,21);
    ele_n(:,17:21) = [];

    if paraflag == 'l'  
        temp=ele_n(:,5);
    end
    ele_n(:,5)=[]; %ɾ��DB
    ele_n(:,4)=[]; %ɾ��Z
    ele_n(:,1)=[]; %ɾ��ԭ������
    if paraflag == 'l' 
        ele_n(:,end+1)=temp*DBmode;
    end
    
    %����֮�ϣ�������Ϊ��
    % ele_n�У��ֱ��ǣ�
    % ԭ������������1-3��DW���ӣ�ԭ����*ռ���ʣ�ab��������ţ�ÿ����˹�ı���
    %֮�����Ϊ������������
    % ele_n������13��
    %����1-2��ռ����*����3��abϵ��   
 
    if ~isempty(absorp_n)  %����Ƿ�Ҫ��������
        %��֮�󣬰���Ҫ�����
       newabsorp_n(:,1)=newabsorp_n(:,1).*newabsorp_n(:,11);
       newabsorp_n(:,3)=newabsorp_n(:,3).*newabsorp_n(:,12);
       newabsorp_n(:,5)=newabsorp_n(:,5).*newabsorp_n(:,13);
       newabsorp_n(:,7)=newabsorp_n(:,7).*newabsorp_n(:,14);
       newabsorp_n(:,9)=newabsorp_n(:,9).*newabsorp_n(:,15);

       newabsorp_n(:,11:15)=[];
    end
end



% xx=[1 2 3; 1 3 2; 1 2 3; 1 0 0];
% [a,b,c]=unique(xx,'rows')
% 
% a =
% 
%      1     0     0
%      1     2     3
%      1     3     2
% 
% 
% b =
% 
%      4
%      1
%      2
% 
% 
% c =
% 
%      2
%      3
%      2
%      1


if ~isempty(all_n_i)
    for i=1:length(slicethick)
        jj = find(all_n_i(:,4) >= slicethick(i)-multiceng*eachthick & all_n_i(:,4) < slicethick(i)+multiceng*eachthick+eachthick);  %�ҵ��������Ҫ���ԭ�����
        series_n_i(i) = length(jj);  %��¼�ж��ٸ�ԭ��λ����һ����
        ele_n_i(end+1:end+length(jj),1:28) = all_n_i(jj,:);
        
         %��������10.bʽ��
        z1(1:length(jj),1) = ele_n_i(end-series_n_i(i)+1:end, 4) -(slicethick(i)+eachthick);
        z2(1:length(jj),1) = ele_n_i(end-series_n_i(i)+1:end, 4) - slicethick(i);
        if i==1
            z2(:)=inf;
        end
        if i==length(slicethick)
            z1(:)=-inf;  
        end
        z2(find(abs(z2)>=multiceng*eachthick)) = inf;
        z1(find(abs(z1)>=multiceng*eachthick)) = -inf;
        
        ele_n_i(end-series_n_i(i)+1:end, 29) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,9),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 30) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,11),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 31) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,13),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 32) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,15),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 33) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,17),  z1, z2);

        ele_n_i(end-series_n_i(i)+1:end, 34) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,20),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 35) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,22),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 36) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,24),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 37) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,26),  z1, z2);
        ele_n_i(end-series_n_i(i)+1:end, 38) = project_poten_contribute(ele_n_i(end-series_n_i(i)+1:end,28),  z1, z2);

        
        if ~isempty(absorp_n_i)  %����Ƿ�Ҫ��������
            newabsorp_n_i(end+1:end+length(jj),1:10) = absorp_n_i(jj,:);
            newabsorp_n_i(end-series_n_i(i)+1:end, 11) = project_poten_contribute(newabsorp_n_i(end-series_n_i(i)+1:end,2),  z1, z2);
            newabsorp_n_i(end-series_n_i(i)+1:end, 12) = project_poten_contribute(newabsorp_n_i(end-series_n_i(i)+1:end,4),  z1, z2);
            newabsorp_n_i(end-series_n_i(i)+1:end, 13) = project_poten_contribute(newabsorp_n_i(end-series_n_i(i)+1:end,6),  z1, z2);
            newabsorp_n_i(end-series_n_i(i)+1:end, 14) = project_poten_contribute(newabsorp_n_i(end-series_n_i(i)+1:end,8),  z1, z2);
            newabsorp_n_i(end-series_n_i(i)+1:end, 15) = project_poten_contribute(newabsorp_n_i(end-series_n_i(i)+1:end,10),  z1, z2);
        end
        z1=[];  %��Ҫ���㣬�������ݿ��ܻᴮ
        z2=[];
        
    end
    %��֮�󣬰���Ҫ�����
       ele_n_i(:,8)=ele_n_i(:,8).*ele_n_i(:,29);
       ele_n_i(:,10)=ele_n_i(:,10).*ele_n_i(:,30);
       ele_n_i(:,12)=ele_n_i(:,12).*ele_n_i(:,31);
       ele_n_i(:,14)=ele_n_i(:,14).*ele_n_i(:,32);
       ele_n_i(:,16)=ele_n_i(:,16).*ele_n_i(:,33);
       
       ele_n_i(:,19)=ele_n_i(:,19).*ele_n_i(:,34);
       ele_n_i(:,21)=ele_n_i(:,21).*ele_n_i(:,35);
       ele_n_i(:,23)=ele_n_i(:,23).*ele_n_i(:,36);
       ele_n_i(:,25)=ele_n_i(:,25).*ele_n_i(:,37);
       ele_n_i(:,27)=ele_n_i(:,27).*ele_n_i(:,38);

       if paraflag == 'l'
          temp=ele_n_i(:,5);
       end
       ele_n_i(:,29:end)=[];
       ele_n_i(:,5)=[]; %ɾ��DB
       ele_n_i(:,4)=[]; %ɾ��Z
       ele_n_i(:,1)=[]; %ɾ��ԭ������
       
       if paraflag == 'l'
          ele_n_i(:,end+1)=temp*DBmode;
       end
       
          

    if ~isempty(newabsorp_n_i)  %����Ƿ�Ҫ��������       
        %��֮�󣬰���Ҫ�����
       newabsorp_n_i(:,1)=newabsorp_n_i(:,1).*newabsorp_n_i(:,11);
       newabsorp_n_i(:,3)=newabsorp_n_i(:,3).*newabsorp_n_i(:,12);
       newabsorp_n_i(:,5)=newabsorp_n_i(:,5).*newabsorp_n_i(:,13);
       newabsorp_n_i(:,7)=newabsorp_n_i(:,7).*newabsorp_n_i(:,14);
       newabsorp_n_i(:,9)=newabsorp_n_i(:,9).*newabsorp_n_i(:,15);

       newabsorp_n_i(:,11:15)=[];
    end
    
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


