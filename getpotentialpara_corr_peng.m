function [corr_nuclear,corr_nuc_ion]  = getpotentialpara_corr_peng(x);  %�����Ҫ���������Ƴ��Ĳ���

[PengPara, PengIon]=ABSFpara;   %��peng��lobato��ϵ����д��
[LotaboPara, LotaboIon]=Lobato_para;

%��ϵ�����뵽�������һ����ԭ����ţ�2-3��aϵ����4-5��bϵ����newss���������û�У�����ϵ���㣻
%newstart��newlast��Q�����������յ�s����
% re=[xu, aaar, bbbr, newss,newstart,newlast,a1_newf,a1,a1_newf_peng,a2_newf,a2,a2_newf_peng,...
%     a3_newf,a3,a3_newf_peng,a4_newf,a4,a4_newf_peng,a5_newf,a5,a5_newf_peng,a6_newf,a6,a6_newf_peng];
re_ion=[];  %����û��ion��������  �����һ�к͵ڶ��зֱ���ԭ����źͼ�̬����������һ��λ��

corr_nuclear=[]; corr_nuc_ion=[];  %����ȸ���
corr_ion=[];

%case 1��ֻ��ԭ���Ի�ֻ��������
b=find(x(:,6)==0);  %�ҳ�ֻ��ԭ���Ե�ԭ��
if ~isempty(b)
    corr_nuclear(:,1) = x(b,1);  %���������
    corr_nuclear(:,2:4) = x(b,2:4); %�������
    corr_nuclear(:,5) = x(b,7); %DB
    corr_nuclear(:,6) = x(b,8).*(1-x(b,6)); %ռ����*������
    corr_nuclear(:,7:16) =  PengPara(corr_nuclear(:,1), [1,6, 2,7, 3,8, 4,9, 5,10]);  %ÿ��ԭ�ӵ�����ϵ������
    corr_nuclear(:,17:26) =  LotaboPara(corr_nuclear(:,1), [1,6, 2,7, 3,8, 4,9, 5,10]);  %ÿ��ԭ�ӵ�����ϵ������
end

b=find(x(:,6)==1);  %�ҳ�ֻ�������Ե�ԭ��
len=length(b);  %�����м��������Ե�  %the ion parameters comes from peng's
if ~isempty(b)
    corr_ion(:,1) = x(b,1);  %���������
    corr_ion(:,2) = x(b,5);  %��ü�̬
    corr_ion(:,3:5) = x(b,2:4); %�������
    corr_ion(:,6) = x(b,7); %DB
    corr_ion(:,7) = x(b,8).*x(b,6); %ռ����*������
    
    [tempjiatai, aa, xuhao] =unique(re_ion(:,1:2),'rows','stable');
    clear aa
    %���������ͼ�̬��Ӧ�Ĳ���������ֵ���µĲ�������
    for i=1:length(tempjiatai(:,1))
        k = find(tempjiatai(i,1)==PengIon(:,1) & tempjiatai(i,2)==PengIon(:,2))
        tempionpara(i, 8:17)  = [PengIon(k,3), PengIon(k,8), PengIon(k,4), PengIon(k,9), PengIon(k,5), ...
                   PengIon(k,10), PengIon(k,6), PengIon(k,11), PengIon(k,7), PengIon(k,12)];  %
        tempionpara(i,18:27) = [LotaboIon(k,3), LotaboIon(k,8), LotaboIon(k,4), LotaboIon(k,9), LotaboIon(k,5), ...
                   LotaboIon(k,10), LotaboIon(k,6), LotaboIon(k,11), LotaboIon(k,7), LotaboIon(k,12)];
    end
    corr_ion(:,8:27) = tempionpara(xuhao, :);   %������ԭ�ӵ������Զ���ֵ����tempionpara����ȡ
end

%����if���жϣ��õ��˵��������Ի�ԭ���ԵĹ涨������� ����˵��.doc�ļ�
if ~isempty(corr_ion)   
    corr_nuclear(end+1:end+len,:)=corr_ion(:,[1,3:end]);  %ȥ���˼�̬����Ϣ����26��
    clear corr_ion
end

% case 2
%�ҳ�����ԭ�������������Ե�ԭ�ӡ�---------------------------------
b=find(x(:,6)>0 & x(:,6)<1);  %�ҳ�ֻ�������Ե�ԭ��
if ~isempty(b)
    corr_nuc_ion(:,1) = x(b,1);  %���������
    corr_nuc_ion(:,2) = x(b,5);  %��ü�̬
    corr_nuc_ion(:,3:5) = x(b,2:4); %�������
    corr_nuc_ion(:,6) = x(b,7); %DB
    corr_nuc_ion(:,7) = x(b,8); %ռ����
    corr_nuc_ion(:,8) = x(b,6); %������
    
    [tempjiatai, aa, xuhao] =unique(corr_nuc_ion(:,1:2),'rows','stable');
    clear aa
    %���������ͼ�̬��Ӧ�Ĳ���������ֵ���µĲ�������
    for i=1:length(tempjiatai(:,1))
        k = find(tempjiatai(i,1)==PengIon(:,1) & tempjiatai(i,2)==PengIon(:,2))
        tempionpara(i, 1:10)  = [PengIon(k,3), PengIon(k,8), PengIon(k,4), PengIon(k,9), PengIon(k,5), ...
                   PengIon(k,10), PengIon(k,6), PengIon(k,11), PengIon(k,7), PengIon(k,12)];  %
        tempionpara(i,11:20) = [LotaboIon(k,3), LotaboIon(k,8), LotaboIon(k,4), LotaboIon(k,9), LotaboIon(k,5), ...
                   LotaboIon(k,10), LotaboIon(k,6), LotaboIon(k,11), LotaboIon(k,7), LotaboIon(k,12)];
%         k = find(tempjiatai(i,1)==re_ion(:,1) & tempjiatai(i,2)==re_ion(:,2));
%         tempionpara(i, 1:6)  = re_ion(k,[3:6,8:9]);
    end
    corr_nuc_ion(:,9:28) = tempionpara(xuhao, :);   %������ԭ�ӵ������Զ���ֵ����tempionpara����ȡ
    
    corr_nuc_ion(:,29) = 1- x(b,6); %ԭ����
    corr_nuc_ion(:,30:39) = PengPara(corr_nuc_ion(:,1), [1,6, 2,7, 3,8, 4,9, 5,10]);
                         %ÿ��ԭ�ӵ�ɢ�����
    corr_nuc_ion(:,40:49) = LotaboPara(corr_nuc_ion(:,1), [1,6, 2,7, 3,8, 4,9, 5,10]);
                         %ÿ��ԭ�ӵ�ɢ�����
    corr_nuc_ion(:,2)=[];  %�ܹ�ֻʣ��48�У�ȥ��������
end
return;