clear;
%导入0%基准
y0=xlsread('标样数据\0%\sbs.xlsx',2);
y0=2-log10(y0);
%导入标准样本
x0=xlsread('标样数据\4.5%\sbs.xlsx',1);
y3=xlsread('标样数据\4.5%\sbs.xlsx',2);
y3=2-log10(y3);
%确定积分区间
a = (x0(length(x0),1)-x0(1,1))/length(x0);
x1 = ceil((660-x0(1,1))/a);
x2 = ceil((706-x0(1,1))/a);
x3 = ceil((1350-x0(1,1))/a);
x4 = ceil((1396-x0(1,1))/a);


namelist1 = dir('SBS_std_76\*.csv');
len = length(namelist1);
PM = [];
M = [];


for j = 1:len
    file_name=namelist1(j).name;
    file = strcat("SBS_std_76\",file_name);
    Z = load(file);
    %导入待测光谱数据
    z=Z(:,2);
    z=2-log10(z);


    y1 = z(x1:x2,:)-y0(x1:x2,:);
    y2 = z(x3:x4,:);
    s1=trapz(y1);
    s2=trapz(y2);
    s3=s1/s2;

    %求相对4.5%标样的平移量（699处）
    syms x A
    A=0;
    for i=x1:x2
        B1=y3(i,1);
        B2=z(i,1);
        A=(x+B2-B1)^2+A;
    end
    z1=z;
    C=diff(A);
    abs3=solve(C==0);
    z1(x1:x2,:)=z(x1:x2,:)+abs3(1,1);
    z11 = z1(x1:x2,:)-y0(x1:x2,:);
    
    %求相对4.5%标样的平移量（1377处）
    syms x A
    A=0;
    for i=x3:x4
        B1=y3(i,1);
        B2=z(i,1);
        A=(x+B2-B1)^2+A;
    end
    C=diff(A);
    abs33=solve(C==0);
    z1(x3:x4,:)=z(x3:x4,:)+abs33(1,1);
    z22 =z1(x3:x4,:);
    S=trapz(z11)/trapz(z22);
    PM(j,1) = S;
    M(j,1) = s3;
end


MPM = mean(PM);
SPM = std(PM);
MM = mean(M);
SM = std(M);


