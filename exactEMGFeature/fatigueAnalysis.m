clc
clear
path="../data/20repetition.txt";
rawData=importdata(path); %有效通道为5~8
rawEMG=rawData.data(:,2);
force=rawData.data(:,1);
emgFeature=TDAR6_RMS(rawEMG,250,100);

meanRMS=zeros(20,1);
signal=emgFeature(:,1);
for i=1:20
    meanRMS(i)=mean(signal(length(signal)*(i-1)/20+1:length(signal)*i/20));
end

signal=rawEMG;
MF=zeros(10,1);
for i=1:10
    MF(i)=cal_MF(signal(length(signal)*(i-1)/10+1:length(signal)*i/10));
end


figure()
x1=1:length(force);
y1=force;
y2=signal(1:length(force));
t_MF=0.5*length(force)/15:length(force)/15:length(force)-0.5*length(force)/15;
[ax,h1,h2]=plotyy(x1,y1,x1,y2);
ylim(ax(1),[-2,5])
ylim(ax(2),[-800,2000])
set(h1,'color','b')
set(h2,'color','g')
hold on
hh=line(t_MF,MF/30);
set(hh,'linestyle','-','linewidth',1.2)
set(hh,'color','r')
set(hh,'marker','*')
hold off
%%设置坐标轴、刻度线宽及颜色;
bx=axes('Position',get(gca,'Position'),...
'XAxisLocation','top',...
'YAxisLocation','right',...
'Color','none',...
'XColor','k','YColor','none','XTick',[],'YTick',[]);
set([ax,bx],'LineWidth',1.2,'XColor','k');
set(ax(1),'YColor','k');
set(ax(2),'YColor','k');
%%设置图形中线宽及Marker
set(h1,'color','b','linestyle','-','marker','o','markersize',0.5,'linewidth',1.2);
set(h2,'color','g','linestyle','-','marker','o','markersize',0.5,'linewidth',1.2);
%%设置刻度线及刻度值字体
set(ax,'FontName','Times New Romance','FontSize',12,'FontWeight','normal');
H=[h1,h2,hh];
legend(H,{'Force','sEMG','MF'},'FontName','Times New Romance','FontSize',12,'FontWeight','bold');