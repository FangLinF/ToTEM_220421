

function Drawsupercell_figure(x_new, atomsize, x_mysavenewz, top, bottom)  %����ԭ�ӵ����꣬ ԭ�ӵķŴ�ߴ�, ���z��߶ȣ�top��bottom��ֵ
%����ԭ�ӽṹ
%��Ҫ�����Ƚ϶����Ϣ�������������pdb��Ϣ����,��һ����Ԫ���������������������꣬������ռ���ʣ������м�װ�Ǽ�̬
atompos = x_new(:,2:4);
atompos(:,4) = x_mysavenewz+top; 
%��ͼ��ʾһ�½ṹ
figure; 
hold on;
view([0 0 -1])

maxx=max(atompos(:,1));
maxy=max(atompos(:,2));
maxz=max(atompos(:,3))+bottom;
mm=max([maxx, maxy, maxz]); 

hold on; line([0 0], [0 0], [0, maxz],'color','b')
line([0 0], [0 maxy], [0, 0],'color','g')
line([0 maxx], [0 0], [0, 0],'color','r')
line([0 0], [0 0], [0, -mm/10],'color','b','linestyle','--')
line([0 0], [0 -mm/10], [0, 0],'color','g','linestyle','--')
line([0 -mm/10], [0 0], [0, 0],'color','r','linestyle','--')

item_ele=unique(x_new(:,1));  %�����м���ԭ��
for i=1:length(item_ele)  %Ԫ�ص�����
    r=1-mod(item_ele(i),5)*0.25;    %����ԭ�����������ø�ԭ�����е���ɫ��r,g,bΪ����ɫ��ֵ
    g=1-mod(floor(item_ele(i)/5),5)*0.25;
    b=1-mod(floor(item_ele(i)/25),5)*0.25;
    %���л�ͼ
    plot3(atompos(find(x_new(:,1)==item_ele(i)),1),...
        atompos(find(x_new(:,1)==item_ele(i)),2), ...
        atompos(find(x_new(:,1)==item_ele(i)),3),'o',...  %��㣬��״Ϊ��o��
         'MarkerEdgeColor',[0 0 0],...    %���ñ�Ե��ɫΪ��ɫ
         'MarkerSize',atomsize.*(20-log2(2)),...  %����ԭ�ӵĴ�С,������ʾcell��Ŀ�����Ӵ�С���С
         'MarkerFaceColor',[r g b]);    %����ԭ�ӵ���ɫ
end
axis equal
xlabel('x'); ylabel('y'); zlabel('z');