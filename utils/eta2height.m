function  height = eta2height(eta, ptop)
%  将WRF模式中eta层相应值转换为相对应层的高度值
%   输入参数:
%        eta  :  对应的 eta 层值
%                向量或标量
%       ptop  :  模式顶气压值，单位: hPa
%   输出参数:
%       height :  eta 层对应的高度值
%%
pbot = 1013.1;
if isvector(eta)
    p = eta.*(pbot - ptop) + ptop;
    height = pre2height(p);
else
    error('Input arguments must be vector!')
end
end

% 前两天在气象家园上看到另外一种关于计算每一层所对应高度的方法，还没有去验证哪一种是对的，现把自己用的程序给放上来一起，有空再去看看两种方案得到的值是否一样
%以读取广州塔这个站点的经度为例
clear all;

ncfile='D:\wrfout\wrfout-nourban-4-7';   %读文件%
A=zeros(30,1);  %先定义一个有1列30行的数值。
t=37;   %由于该文件有多个时刻，所以先去某个时刻，不同的时刻，下面变量对应的值其实是不一样的

for z=1:30 ; %由于我跑设置的eta值有30个，所以这里得到的结果也应该是30个垂直方向的高度。
ph=ncread(ncfile,'PH');  %PH 'perturbation geopotential' ’ 'm2 s-2'
ph=squeeze(phsz(:,:,z,t)); %squeeze函数可以降低维度  
[x1,y1]=findpoint(113.335301,23.116757,lonmodel,latmodel); %广州塔经纬度 findpoint函数可以找到该经纬度所对应的格点信息
ph=ph(x1,y1);  %读取该格点的值

phb=ncread(ncfile,'PHB');  %'base-state geopotential' 'm2 s-2'
phb=squeeze(phbsz(:,:,z,t)); 
[x1,y1]=findpoint(113.335301,23.116757,lonmodel,latmodel); %广州塔经纬度
phb=phb(x1,y1);  %读取该格点的值

hgt=ncread(ncfile,'HGT');  %  description = ''Terrain Height'    units       = 'm'
hgt=squeeze(hgtsz(:,:,t)); 
[x1,y1]=findpoint(113.335301,23.116757,lonmodel,latmodel); %广州塔经纬度
hgt=hgt(x1,y1);  %读取该格点的值

A(z,1)=((ph+phb)/9.81)-hgt;

end
