% NormalizeDatas.m
% 23.01.2023
% Dos Reis F.
% function that gives normalized matrix datas 

function [datas_n,moyenne,ecart_type]=NormalizeDatas(datas)
 moyenne=mean(datas,2);
 ecart_type=std(datas,0,2);
 
 ldatas=size(datas,2);
 D=ones(1,ldatas);
 E=moyenne.*D;
 F=ecart_type.*D;
 
 G=datas-E;
 datas_n=(G./F);
end