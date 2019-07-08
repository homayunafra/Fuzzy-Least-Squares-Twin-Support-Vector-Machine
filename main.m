function main()
clc
warning off

%-------------- Load the data --------------
MainData = csvread('Ionosphere.csv');
dataSet = MainData(:,1:end-1);
classes = MainData(:,end);

[m1 m11] = size(MainData)
KA = ones(m1,m1);
for i = 1:m1
    for j = 1:m1
        KA(i,j) = kernel('RBF', dataSet(i,:), dataSet(j,:));
    end
end

dataSet = KA;
MainData = [dataSet classes];

%-------------- Compute membership degrees (to be used by FLST-SVM) --------------
% memberships= MainData(:,end);
c1 = MainData(:,end) == 1;
c2 = MainData(:,end) == 2;

Center1 = sum(MainData(c1,:))/sum(c1);
Center2 = sum(MainData(c2,:))/sum(c2);
radious1 = 0;
radious2 = 0;

for i = 1:size(MainData)
    if MainData(i,end) == 1 & radious1 < norm(MainData(i,:)-Center1,2)
        radious1 = norm(MainData(i,:)-Center1,2);
    end
    if MainData(i,end) == 2 & radious2 < norm(MainData(i,:)-Center2,2)
        radious2 = norm(MainData(i,:)-Center2,2);
    end
end

for i = 1:size(MainData)
    if MainData(i,end) == 1
        memberships(i) = 1-norm(MainData(i,:)-Center1,2)/(radious1+ 0.0001);
    end
    if MainData(i,end) == 2
         memberships(i) = 1- norm(MainData(i,:)-Center2,2)/(radious2+ 0.001);
    end
end

%-------------- Run the classifier for the data --------------
cnew = 1.5;
sigmanew = 1.8;
classifier_output = call_classifier(memberships', dataSet, classes, 'lstsvm', cnew, sigmanew);

end


