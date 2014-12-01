clear all;clc;

load('kda10_lv3.mat');
inputX = csvread('../../data/dota2_lv3_feat');
inputY = csvread('../../data/dota2_lv3_label');

%inputX = csvread('../../data/kda_10Filtered/dota2_lv3Feature.csv');
%inputY = csvread('../../data/kda_10Filtered/dota2_lv3Label.csv');

fid = fopen('newFeat.csv','w+');
fid0 = fopen('oldFeat.csv','w+');
fid1 = fopen('label.csv','w+');

SampNum = size(inputX,1);
featDim = size(inputX,2);
ct = 0;

for i = 1:SampNum
 %   if ct == 50000
  %      break;
   % end
    
    featA = zeros(1,108);
    featB = featA;
    A = find(inputX(i,:) == 1);
    B = find(inputX(i,:) == -1);
    
    if length(A) ~= 5 || length(B) ~= 5
        continue;
    end
    
    featA(1,A)=1;
    featB(1,B)=1;
    
    fA_bkup = featA;
    fB_bkup = featB;
    feat_old = [featA,featB];

    for j = 1:5
        featA(1,A(j)) = prod(matrix(A(j),B));
        featB(1,B(j)) = prod(matrix(B(j),A));
    end
    
    feat=[featA,featB];
    maxVal = max(feat);
    minVal = min(feat);
    
    
    featA = (featA-minVal) / (maxVal-minVal);
    featB = (featB-minVal) / (maxVal-minVal);
    feat = [fA_bkup,featA,fB_bkup,featB];

    fprintf(fid,'%g,',feat(1:length(feat)-1));
    fprintf(fid,'%g',feat(length(feat)));
    fprintf(fid,'\n');
    
    fprintf(fid0,'%g,',feat_old(1:length(feat_old)-1));
    fprintf(fid0,'%g',feat_old(length(feat_old)));
    fprintf(fid0,'\n');
    
    
    % label
    if inputY(i) == 1 
        l = 1;
    else
        l = -1;
    end
    fprintf(fid1,'%g\n',l);
    ct = ct + 1;
end

fclose(fid);
fclose(fid0);
fclose(fid1);









% clear all;clc;
% 
% 
% load('kda10_lv3.mat');
% inputX = csvread('../../data/dota2_lv3_feat');
% 
% fid = fopen('newFeat.csv','w+');
% 
% SampNum = size(inputX,1);
% featDim = size(inputX,2);
% 
% for i = 1:SampNum
%     featA = zeros(108,5);
%     featB = featA;
%     A = find(inputX(i,:) == 1);
%     B = find(inputX(i,:) == -1);
%     
%     %featA(A,1)=1;
%     %featB(B,1)=1;
% 
%     for j = 1:5
%         featA(B,j) = matrix(A(j),B);
%         featB(A,j) = matrix(B(j),A);
%     end
%     
%     featA = reshape(featA,1,540);
%     featB = reshape(featB,1,540);
%     fprintf(fid,'%g,',featA(1:length(featA)-1));
%     fprintf(fid,'%g',featA(length(featA)));
%     fprintf(fid,'\n');
%     
%     %fprintf(fid,'%g,',featB(1:length(featB)-1));
%     %fprintf(fid,'%g',featB(length(featB)));
%     %fprintf(fid,'\n');
% end
% 
% fclose(fid);




% 2 row feature
% clear all;clc;
% 
% load('kda10_lv3.mat');
% inputX = csvread('../../data/dota2_lv3_feat');
% 
% fid = fopen('newFeat.csv','w+');
% fid0 = fopen('oldFeat.csv','w+');
% 
% SampNum = size(inputX,1);
% featDim = size(inputX,2);
% 
% for i = 1:SampNum
%     featA = zeros(1,108);
%     featB = featA;
%     A = find(inputX(i,:) == 1);
%     B = find(inputX(i,:) == -1);
%     
%     featA(1,A)=1;
%     featB(1,B)=1;
%     
%     feat_old = [featA,featB];
% 
%     for j = 1:5
%         featA(1,A(j)) = sum(matrix(A(j),B));
%         featB(1,B(j)) = sum(matrix(B(j),A));
%     end
%     
%     feat=[featA,featB];
%     maxVal = max(feat);
%     minVal = min(feat);
%     
%     feat = (feat-minVal) / (maxVal-minVal);
% 
%     fprintf(fid,'%g,',feat(1:length(feat)-1));
%     fprintf(fid,'%g',feat(length(feat)));
%     fprintf(fid,'\n');
%     
%     fprintf(fid0,'%g,',feat_old(1:length(feat_old)-1));
%     fprintf(fid0,'%g',feat_old(length(feat_old)));
%     fprintf(fid0,'\n');
% end
% 
% fclose(fid);
% fclose(fid0);
