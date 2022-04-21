%cuda�ĺ��ļ��㣬��cpu���㷨
function [aamyresul, aamidresul]=cuda_STEM_CPU_Mcore_lobato_peng_corr(PARAMETER, sigma, ...%��������Щԭ�ӣ�ÿ��ԭ�Ӷ��ٸ�������parameter��potential��;�໥����ϵ��sigama����͸��������Ҫ��
    ele_n, absorp_n, ....�������ӻ���ԭ�ӵĵ��Ժ�����
    ele_n_i, absorp_n_i, ... %ԭ�ӻ�ԭ��+���ӣ����Ի�������
    series_n, series_n_i, ...  %ԭ�����д���
    ele_n_corr, ele_n_i_corr, corr_info, ... %��������peng��ϵ��������������Ƴ�����
    series_n_corr, series_n_i_corr,...
    gx_green, gy_green, s2, APERTURE,...   %��ɫ�������potentialʱ��gx��gy��������ԭ��λ����صĵ���ʸ��s2����peng potential��,APERTURE�Ƿ�ֹ2/3�����ⷢ��wrap������ʼ�
    probe, gfsf, psf_fft, ...%probe����ʽ�����м�������ı������䣬��������
    green_Ncol, green_Nrow, ...%��ɫ�ĳߴ磬��ɫ���ռ��sx��sy��
    probe_ingreenNrow, probe_ingreenNcol, ...
    width_red, hight_red, probestep, ...  %ѡȡ�����λ�õ����Ͻ�x��y���꣬�Լ����½�x��y����
    APER,paraflag, midslice);  %������ӵĹ�������������lobato����peng�Ĳ���������

%����ÿ����Ƴ�
% potential=GetPotential4AllSlice_multicore_lotabo_peng(green_Ncol, green_Nrow,... 
%     ele_n, absorp_n, ....�������ӻ���ԭ�ӵĵ��Ժ�����
%     ele_n_i, absorp_n_i, ... %ԭ�ӻ�ԭ��+���ӣ����Ի�������
%     series_n, series_n_i, ...  %ԭ�����д���
%     s2, gx_green, gy_green, ...
%     sigma, PARAMETER, APERTURE, paraflag);   %Ϊ��STEM���㲻��������ֻ���뵽HRTEM��CBED��
potential=GetPotential4AllSlice_multicore_lobato_peng_corr(green_Ncol, green_Nrow,... 
    ele_n, absorp_n, ....�������ӻ���ԭ�ӵĵ��Ժ�����  %��������������peng�Ĳ���
    ele_n_i, absorp_n_i, ... %ԭ�ӻ�ԭ��+���ӣ����Ի�������
    series_n, series_n_i, ...  %ԭ�����д���   
    ele_n_corr, ele_n_i_corr, corr_info, ... %�������peng��ϵ��������������Ƴ�����
    series_n_corr, series_n_i_corr,...
    s2, gx_green, gy_green, ...
    sigma, PARAMETER, APERTURE, paraflag);   %Ϊ��STEM���㲻��������ֻ���뵽HRTEM��CBED��

%����
[probesx, probesy]=size(probe);


for i=0:width_red-1;
     tempresul(i+1).matrix = zeros(hight_red,length(APER(1,1,:)));  %����
     midtempresul(i+1).matrix= zeros(hight_red,length(APER(1,1,:)),length(midslice));  %����
end
% parfor i=0:width_red-1;
%     i
%     for j=0:hight_red-1;
%         for nn=1:length(gfsf);
%             mywave=probe(:,:,nn);  %���벨����
%             for k=1:length(potential(1,1,:));
%                 mywave =  mywave.*potential(j*probestep+probe_ingreenNrow:j*probestep+probe_ingreenNrow+probesx-1, ...
%                    i*probestep+probe_ingreenNcol:i*probestep+probe_ingreenNcol+probesx-1,k);
%                    mywave=fft2(mywave);   %ע�⣬��ʡ��һ��fftshift
%                    mywave=mywave.*psf_fft;
%                    mywave=ifft2(mywave);
%             end
%             mywave=fftshift(fft2(mywave));
%             for kk=1:length(APER(1,1,:))    
%                 tempresul(i+1).matrix(j+1,kk)=tempresul(i+1).matrix(j+1,kk)+gfsf(nn).*sum(sum(abs(mywave.*APER(:,:,kk)).^2));%��ͨ����ͨ�����ͨ����
%                 %myresul(j+1,i+1,kk)=myresul(j+1,i+1,kk)+gfsf(nn).*sum(sum(abs(mywave.*APER(:,:,kk)).^2));  %��ͨ����ͨ�����ͨ����
%             end
%         end
%     end
% end

for kk=1:length(APER(1,1,:))    
       APER(:,:,kk)=ifftshift(APER(:,:,kk));  %�ѹ������������·���һ��
end 

mypar=parpool;
parfor i=0:width_red-1;
    i
    for j=0:hight_red-1;
        for nn=1:length(gfsf);
            mywave=probe(:,:,nn);  %���벨����
            for k=1:length(potential(1,1,:));
                mywave =  mywave.*potential(j*probestep+probe_ingreenNrow:j*probestep+probe_ingreenNrow+probesx-1, ...
                   i*probestep+probe_ingreenNcol:i*probestep+probe_ingreenNcol+probesx-1,k);
                   mywave=fft2(mywave);   %ע�⣬��ʡ��һ��fftshift
                   mywave=mywave.*psf_fft;
                   
                   if ~isempty(find(midslice==k, 1))
                       oo=find(midslice==k, 1);
                       for kk=1:length(APER(1,1,:))    
                          midtempresul(i+1).matrix(j+1,kk,oo)=midtempresul(i+1).matrix(j+1,kk,oo)+gfsf(nn).*sum(sum(abs(mywave.*APER(:,:,kk)).^2));%��ͨ����ͨ�����ͨ����
                       end 
                   end
                   mywave=ifft2(mywave);
            end
            mywave=fft2(mywave);
            for kk=1:length(APER(1,1,:))    
                 tempresul(i+1).matrix(j+1,kk)=tempresul(i+1).matrix(j+1,kk)+gfsf(nn).*sum(sum(abs(mywave.*APER(:,:,kk)).^2));%��ͨ����ͨ�����ͨ����
            end 
        end
    end
end
delete(mypar)

myresul=zeros(width_red, hight_red, length(APER(1,1,:)));
midresul=zeros(width_red, hight_red, length(APER(1,1,:)),length(midslice));
for i=0:width_red-1;
    for j=1:length(midslice)
        midresul(i+1,:,:,:) = midtempresul(i+1).matrix(:,:,:);
    end
    myresul(i+1,:,:) = tempresul(i+1).matrix(:,:);
end

clear tempresul
clear midtempresul
aamidresul = zeros(hight_red*width_red*length(APER(1,1,:)),length(midslice));
aamyresul = zeros(hight_red*width_red,length(APER(1,1,:)));
aamidresul(:) = midresul(:);
aamyresul(:) = myresul(:);
clear tempresul
% for kk=1:length(APER(1,1,:)) 
%     figure;imshow(myresul(:,:,kk)/handles.width_red/handles.height_red,[]);colorbar
% end
return