function [Correctrate, ErrorRate] = call_classifier(memberships, dataSet, classes, c)

    KfoldNumber=10;

    indices = crossvalind('Kfold', classes, KfoldNumber);
    flstsvm_cp = classperf(classes);
    for i = 1:(KfoldNumber-1)
        
        test = (indices == i);
        train = ~test;

        ClassA = dataSet(classes == 2 & train == 1, :);
        ClassB = dataSet(classes == 1 & train == 1, :);
        
        MembershipA = memberships(classes == 2 & train == 1, :);
        MembershipB = memberships(classes == 1 & train == 1, :);
        
        testdata = dataSet(test == 1, :);
        [flstsvm_struct] = flstsvm(MembershipA, MembershipB, ClassA, ClassB, c);
        [resultClass] = 1 + sample_classifier(flstsvm_struct, testdata);
        classperf(flstsvm_cp, resultClass, test);
        Correctrate(i) = flstsvm_cp.Correctrate

    end

end