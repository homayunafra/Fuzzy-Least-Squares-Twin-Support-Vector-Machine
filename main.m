function main()
    clc;
    warning off

    %-------------------------load a dataset---------------------------
    %------------------------- Pima-Indian ----------------

    MainData = csvread('Data Sets/Diabet.csv');

    dataSet = MainData(:,1:(end-1));
    classes = MainData(:,end);

    [m, ~] = size(MainData);


    c1 = (MainData(:,end) == 1);
    c2 = (MainData(:,end) == 2);

    Center1 = sum(MainData(c1,:)) / sum(c1);
    Center2 = sum(MainData(c2,:)) / sum(c2);
    radious1 = 0;
    radious2 = 0;

    for i = 1:m
        if (MainData(i,end) == 1) & (norm(MainData(i,:) - Center1, 2) > radious1)
            radious1 = norm(MainData(i,:) - Center1, 2);
        end
        if (MainData(i,end) == 2) & (norm(MainData(i,:) - Center2, 2) > radious2)
            radious2 = norm(MainData(i,:) - Center2, 2);
        end
    end

    for i = 1:m
        if MainData(i,end) == 1
            memberships(i) = 1 - norm(MainData(i,:) - Center1, 2) / (radious1 + 0.0001);
        end
        if MainData(i,end) == 2
             memberships(i) = 1 - norm(MainData(i,:) - Center2, 2) / (radious2 + 0.001);
        end
    end

    c = 1.5;
    call_classifier(memberships', dataSet, classes, c);

end


