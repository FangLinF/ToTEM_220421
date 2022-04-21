function [all_nuclear,all_nuc_ion]  = getpotentialpara_lotabo_peng(x,flag); 
% 20210223 Ŀǰlotaboֻ�и���ԭ�ӵ����ԣ�������������ʹ�õ����������ԣ����Ҫʹ������ʦ�ģ���Ҫ����ת��һ��
% ����flag������ת������һЩ������������ʸ�һЩ
if flag=='p'|| flag=='n'  %��������
     [PengPara, PengIon]=ABSFpara;  %������еĲ��� %so, only peng's parameter and cannot be used further
elseif flag=='l' %lotabo
     [LotaboPara, LotaboIon]=Lobato_para;  %get all parameters of lotabo  %20210223 now ion is empty
%else flag == 'k' %kirkland  %������12�����벻�������޸�Ҫ�Ƚϴ����� 
end
if flag=='l'   %�����ʹ��lotabo�Ĳ�������ʮ�����ӵĲ�����ֵ��peng�ľ����Ա����ʹ��
    PengPara=LotaboPara;
end
%x��������ԭ�ӵ���Ϣ����1��3����ԭ�����ꣻ��4����ԭ�ӵ�����������5���Ǽ�̬��
%��6���������ԣ���7����debye����8����ռ����
          % %��Ҫ����õ�x

all_nuclear=[]; all_nuc_ion=[];  %����ȸ���
all_ion=[];

%case 1��ֻ��ԭ���Ի�ֻ��������
b=find(x(:,6)==0);  %�ҳ�ֻ��ԭ���Ե�ԭ��
if ~isempty(b)
    all_nuclear(:,1) = x(b,1);  %���������
    all_nuclear(:,2:4) = x(b,2:4); %�������
    all_nuclear(:,5) = x(b,7); %DB
    all_nuclear(:,6) = x(b,8).*(1-x(b,6)); %ռ����*������
    all_nuclear(:,7:16) =  [PengPara(all_nuclear(:,1), 1), PengPara(all_nuclear(:,1), 6), PengPara(all_nuclear(:,1), 2), ...
                        PengPara(all_nuclear(:,1), 7), PengPara(all_nuclear(:,1), 3),...
                        PengPara(all_nuclear(:,1), 8), PengPara(all_nuclear(:,1), 4), PengPara(all_nuclear(:,1), 9), ...
                        PengPara(all_nuclear(:,1), 5), PengPara(all_nuclear(:,1), 10)]; %ÿ��ԭ�ӵ�peng��ɢ�����
end

b=find(x(:,6)==1);  %�ҳ�ֻ�������Ե�ԭ��
len=length(b);  %�����м��������Ե�  %the ion parameters comes from peng's
if ~isempty(b)
    all_ion(:,1) = x(b,1);  %���������
    all_ion(:,2) = x(b,5);  %��ü�̬
    all_ion(:,3:5) = x(b,2:4); %�������
    all_ion(:,6) = x(b,7); %DB
    all_ion(:,7) = x(b,8).*x(b,6); %ռ����*������
    
    [tempjiatai, aa, xuhao] =unique(all_ion(:,1:2),'rows','stable');
    clear aa
    %���������ͼ�̬��Ӧ�Ĳ���������ֵ���µĲ�������
    for i=1:length(tempjiatai(:,1))
        k = find(tempjiatai(i,1)==PengIon(:,1) & tempjiatai(i,2)==PengIon(:,2));
        tempionpara(i, :)  = [PengIon(k,3), PengIon(k,8), PengIon(k,4), PengIon(k,9), PengIon(k,5), ...
                   PengIon(k,10), PengIon(k,6), PengIon(k,11), PengIon(k,7), PengIon(k,12)];
    end
    all_ion(:,8:17) = tempionpara(xuhao, :);   %������ԭ�ӵ������Զ���ֵ����tempionpara����ȡ
end

%����if���жϣ��õ��˵��������Ի�ԭ���ԵĹ涨������� ����˵��.doc�ļ�
if ~isempty(all_ion)   
    all_nuclear(end+1:end+len,:)=all_ion(:,[1,3:end]);
    clear all_ion
end

% case 2
%�ҳ�����ԭ�������������Ե�ԭ�ӡ�---------------------------------
b=find(x(:,6)>0 & x(:,6)<1);  %�ҳ�ֻ�������Ե�ԭ��
if ~isempty(b)
    all_nuc_ion(:,1) = x(b,1);  %���������
    all_nuc_ion(:,2) = x(b,5);  %��ü�̬
    all_nuc_ion(:,3:5) = x(b,2:4); %�������
    all_nuc_ion(:,6) = x(b,7); %DB
    all_nuc_ion(:,7) = x(b,8); %ռ����
    all_nuc_ion(:,8) = x(b,6); %������
    
    [tempjiatai, aa, xuhao] =unique(all_nuc_ion(:,1:2),'rows','stable');
    clear aa
    %���������ͼ�̬��Ӧ�Ĳ���������ֵ���µĲ�������
    for i=1:length(tempjiatai(:,1))
        k = find(tempjiatai(i,1)==PengIon(:,1) & tempjiatai(i,2)==PengIon(:,2));
        tempionpara(i, 1:10)  = [PengIon(k,3), PengIon(k,8), PengIon(k,4), PengIon(k,9), PengIon(k,5), ...
                   PengIon(k,10), PengIon(k,6), PengIon(k,11), PengIon(k,7), PengIon(k,12)];
    end
    all_nuc_ion(:,9:18) = tempionpara(xuhao, :);   %������ԭ�ӵ������Զ���ֵ����tempionpara����ȡ
    
    all_nuc_ion(:,19) = 1- x(b,6); %ԭ����
    all_nuc_ion(:,20:29) = [PengPara(all_nuc_ion(:,1), 1), PengPara(all_nuc_ion(:,1), 6), PengPara(all_nuc_ion(:,1), 2), ...
                        PengPara(all_nuc_ion(:,1), 7), PengPara(all_nuc_ion(:,1), 3),...
                        PengPara(all_nuc_ion(:,1), 8), PengPara(all_nuc_ion(:,1), 4), PengPara(all_nuc_ion(:,1), 9), ...
                        PengPara(all_nuc_ion(:,1), 5), PengPara(all_nuc_ion(:,1), 10)]; %ÿ��ԭ�ӵ�ɢ�����
    all_nuc_ion(:,2)=[];
end
return;