function [all_nuclear, all_nuc_ion, absorp_n, absorp_n_i, corr_peng_nuc, corr_peng_nuc_ion]=CommonPart_forsimulation_lotabo_peng(hObject, eventdata, handles, flag);
%����ȷ���Ƿ������գ�����������գ�����һ�����վ���
%�������󣬿���ԭ���Ժͣ��������ԣ���Ӧһ������վ������վ���
%�Ƿ��B��˥��������ǣ����е����պ�ԭ���Ժ������ԣ�����b���޸Ĳ�����
%step 0
%������ѡ��ģ�����򣬼�������ԭ�ӵ�����λ��;��Ҫ���show�����н��
load allresul.mat   %�����ǴӴ洢��allresul��ȡx_new���
x=allresul.x_new;
% x=handles.x_new;

%x(:,2:4)=handles.atompos;   
x=x(find(x(:,2)>=handles.tl_green(1) & x(:,2)<=handles.rd_green(1) ...
    & x(:,3)>=handles.tl_green(2) & x(:,3)<=handles.rd_green(2)),:);%��λ����ɫ�����ԭ�Ӷ�ɾ��
x(:,2:3)=x(:,2:3)-repmat(handles.tl_green, length(x(:,1)),1);   %��Ҫת������ɫ���������Чλ�á�
%tl_green��rd_green��������һ���ģ�����STRM,HRTEM��CBED


%step 1
%���㵯���Ƶľ��󣬷ֵ�����1�͵�����2��
              %������1ֻ����ԭ���Ի�������
              %������2ͬʱ����ԭ���ƺ�������
[all_nuclear,all_nuc_ion]  = getpotentialpara_lotabo_peng(x, flag); 
%�޸�����
%�����correct��������������ĺ���-------------------
corr_peng_nuc=[]; corr_peng_nuc_ion=[];
if flag == 'n'
    [corr_peng_nuc, corr_peng_nuc_ion] = getpotentialpara_corr_peng(x);  %��ù���peng��ʦ������
    if ~get(handles.radiobutton14, 'value') & ~get(handles.radiobutton4, 'value')  %����ǲ�ʹ��DW˥����AP������
        if ~isempty(corr_peng_nuc)
            corr_peng_nuc(:,5) = 0;  %������debye waller���Ӳ�Ӱ��˥�����Ƴ�,���ǰ�dw������Ϊ0������˥���ӵ��Ƴ��ϲ�Ӱ����
        end
        if ~isempty(corr_peng_nuc_ion)
            corr_peng_nuc_ion(:,5) = 0;  %������debye waller���Ӳ�Ӱ��˥�����Ƴ�
        end
    end
end
%--------------------------------------------

%����ԭ������
len1=0; len2=0;
if ~isempty(all_nuclear)
    len1=length(all_nuclear(:,1));
end
if ~isempty(all_nuc_ion)
    len2=length(all_nuc_ion(:,1));
end
    
%step 2
%�����������absorptive potential
absorp_n=[];  absorp_n_i=[];  % ���ó�ֵ
element_n=[]; element_n_i=[];
if get(handles.radiobutton4, 'value')   %�������գ��������ѹ�Լ�DebyeWaller�����й�
    if ~isempty(all_nuclear)
        absorp_n=zeros(len1, 10);
        %��������ԭ�ӵ�������
        element_n=unique([all_nuclear(:,1).';all_nuclear(:,5).'].','row');      
    end
    if ~isempty(all_nuc_ion)
        absorp_n_i=zeros(len2, 10);
        %��������ԭ�ӵ�������
        element_n_i=unique([all_nuc_ion(:,1).';all_nuc_ion(:,5).'].','row');
    end
    %���������Ժ�ԭ�����ܹ�����������Ԫ������Щ
    allelement=unique([element_n;element_n_i],'row');
    for i=1:length(allelement(:,1))  %��ÿ��ԭ�ӣ������ǵ������Ƴ�  20210223��һ���ǲ�һ����
          myresul(i,:)=mynewftds_ab_lotabo_peng(allelement(i,1),allelement(i,2),str2num(get(handles.edit_Vol, 'string')),flag);  
          %4����������һ����ԭ�����������ڶ�����B���ӣ��������ǵ�ѹ��λ��ǧ�������ĸ��Ǽ��㷽����p��l�ֱ����peng��lotabo
    end
    
    if ~isempty(element_n)
        absorp_n=zeros(length(all_nuclear(:,1)),10);
        for i=1:length(allelement(:,1));  %ÿ��ԭ�ӵ�����
            e=find(all_nuclear(:,1)==allelement(i, 1) & all_nuclear(:,5)==allelement(i, 2));   %�ҵ���������Bһ�µ�ԭ�ӵ����
            absorp_n(e,:)=repmat(myresul(i,:),length(e),1);  %���������abϵ��������������Ӧ��ԭ�������
        end
    end
    if ~isempty(element_n_i)
        absorp_n_i=zeros(length(all_nuc_ion(:,1)),10);
        for i=1:length(allelement(:,1));  %ÿ��ԭ�ӵ�����
            e=find(all_nuc_ion(:,1)==allelement(i, 1) & all_nuc_ion(:,5)==allelement(i, 2));   %�ҵ���������Bһ�µ�ԭ�ӵ����
            absorp_n_i(e,:)=repmat(myresul(i,:),length(e),1);  %���������abϵ��������������Ӧ��ԭ�������
        end
    end
    
end

%step 3
if flag == 'p'|| flag=='n'  %20210223  %ֻ�����ϵ���������²���������peng����������b+B
   %�������debye waller��˥�����ޣ����е�b��ص�ϵ������Ҫ����B�ĳ���
   %20201230�޸�
    %����Ӧ������b_re��b_im����B
    if get(handles.radiobutton14, 'value') || get(handles.radiobutton4, 'value')  %�����DWѡ�񣬾���Ҫ����DW��Ӱ�졣
        if ~isempty(all_nuclear)
            all_nuclear(:,8) = all_nuclear(:,8)+all_nuclear(:,5);
            all_nuclear(:,10) = all_nuclear(:,10)+all_nuclear(:,5);
            all_nuclear(:,12) = all_nuclear(:,12)+all_nuclear(:,5);
            all_nuclear(:,14) = all_nuclear(:,14)+all_nuclear(:,5);
            all_nuclear(:,16) = all_nuclear(:,16)+all_nuclear(:,5);
        end

        if ~isempty(all_nuc_ion)
            all_nuc_ion(:,9) = all_nuc_ion(:,9)+all_nuc_ion(:,5);
            all_nuc_ion(:,11) = all_nuc_ion(:,11)+all_nuc_ion(:,5);
            all_nuc_ion(:,13) = all_nuc_ion(:,13)+all_nuc_ion(:,5);
            all_nuc_ion(:,15) = all_nuc_ion(:,15)+all_nuc_ion(:,5);
            all_nuc_ion(:,17) = all_nuc_ion(:,17)+all_nuc_ion(:,5);
        
            all_nuc_ion(:,20) = all_nuc_ion(:,20)+all_nuc_ion(:,5);
            all_nuc_ion(:,22) = all_nuc_ion(:,22)+all_nuc_ion(:,5);
            all_nuc_ion(:,24) = all_nuc_ion(:,24)+all_nuc_ion(:,5);
            all_nuc_ion(:,26) = all_nuc_ion(:,26)+all_nuc_ion(:,5);
            all_nuc_ion(:,28) = all_nuc_ion(:,28)+all_nuc_ion(:,5);
        
        end
    end
end
if flag == 'l'  %20210223  %���ʱlotabo��ϵ�������κβ���
    if get(handles.radiobutton14, 'value') || get(handles.radiobutton4, 'value')  %�����DWѡ�񣬾���Ҫ����DW��Ӱ�졣
         disp('Lotabo parameters cannot add debye waller in this step, the potential will be add exp(-Bs^2)�� not here')
    end
end
    
if get(handles.radiobutton4, 'value')   %�������AP���Ƶ�����  
    %�������������peng��ʦ����lotaboϵ����ϳ����ĸ�˹�ߣ�����Ҫ����b��ϵ���ļ�0.5B   
    if ~isempty(absorp_n)
        absorp_n(:,2)=absorp_n(:,2) + 0.5*all_nuclear(:,5);   %ע�⣬������0.5��ϵ��
        absorp_n(:,4)=absorp_n(:,4) + 0.5*all_nuclear(:,5);
        absorp_n(:,6)=absorp_n(:,6) + 0.5*all_nuclear(:,5);
        absorp_n(:,8)=absorp_n(:,8) + 0.5*all_nuclear(:,5);
        absorp_n(:,10)=absorp_n(:,10) + 0.5*all_nuclear(:,5);
    end
    
    if ~isempty(absorp_n_i)
        absorp_n_i(:,2)=absorp_n_i(:,2) + 0.5*all_nuc_ion(:,5);
        absorp_n_i(:,4)=absorp_n_i(:,4) + 0.5*all_nuc_ion(:,5);
        absorp_n_i(:,6)=absorp_n_i(:,6) + 0.5*all_nuc_ion(:,5);
        absorp_n_i(:,8)=absorp_n_i(:,8) + 0.5*all_nuc_ion(:,5);
        absorp_n_i(:,10)=absorp_n_i(:,10) + 0.5*all_nuc_ion(:,5);
    end
end

return