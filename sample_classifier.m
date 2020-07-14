function [result] = sample_classifier(TsvmStruct, testcasedata)

    [m, ~] = size(testcasedata);

    w1 = TsvmStruct.W1;
    b1 = TsvmStruct.B1;
    c1 = TsvmStruct.C1;
    d1 = TsvmStruct.D1;
    w2 = TsvmStruct.W2;
    b2 = TsvmStruct.B2;
    c2 = TsvmStruct.C2;
    d2 = TsvmStruct.D2;

    delta1 = abs(testcasedata * w1 + b1);
    gamma1 = abs((testcasedata * (w1 + c1)) + b1 + d1);
    for i = 1:size(testcasedata)
        gamma1(i) = max([abs(testcasedata(i, :) * (w1 + c1) + b1 + d1), 
                        abs(testcasedata(i, :) * (w1 - c1) + b1 + d1), 
                        abs(testcasedata(i, :) * (w1 + c1) + b1 - d1),
                        abs(testcasedata(i, :) * (w1 - c1) + b1 - d1)]);
    end


    delta2 = abs((testcasedata * w2) + b2);

    gamma2 = abs((testcasedata * (w2 + c2)) + d2);

    for i = 1:size(testcasedata)
        gamma2(i) = max([abs(testcasedata(i, :) * (w2 + c2) + b2 + d2),
                        abs(testcasedata(i, :) * (w2 - c2) + b2 + d2),
                        abs(testcasedata(i, :) * (w2 + c2) + b2 - d2),
                        abs(testcasedata(i, :) * (w2 - c2) + b2 - d2)]);
    end


    for i=1:m
        mu1 = 1;
        mu2 = 1;
        
        if (delta1(i) >= gamma1(i)) && (delta2(i) >= gamma2(i))
            mu1 = (1 - ((delta1(i) + gamma1(i)) / (delta1(i) + gamma1(i) + delta2(i) + gamma2(i))));
        elseif (delta1(i) < gamma1(i)) && (delta2(i) >= gamma2(i))
            mu1 = (1 -  (delta1(i) / (delta1(i) + delta2(i) + gamma2(i))));
        elseif (delta1(i) >= gamma1(i)) && (delta2(i) < gamma2(i))
            mu1 = (1 - ((delta1(i) + gamma1(i))/(delta1(i) + gamma1(i) + delta2(i))));
        elseif (delta1(i) < gamma1(i)) && (delta2(i) < gamma2(i))
            mu1 = (1 - (delta1(i) / (delta1(i) + delta2(i))));
        end

        if (delta2(i) >= gamma2(i)) && (delta1(i) >= gamma1(i))
            mu2=(1 - ((delta2(i) + gamma2(i)) / (delta2(i) + gamma2(i) + delta1(i) + gamma1(i))));
        elseif (delta2(i) < gamma2(i)) && (delta1(i) >= gamma1(i))
            mu2 = (1 - (delta2(i) / (delta2(i) + delta1(i) + gamma1(i))));
        elseif (delta2(i) >= gamma2(i)) && (delta1(i) < gamma1(i))
            mu2 = (1 - ((delta2(i) + gamma2(i)) / (delta2(i) + gamma2(i) + delta1(i))));
        elseif (delta2(i) < gamma2(i)) && (delta1(i) < gamma1(i))
            mu2 = (1 - (delta2(i) / (delta2(i) + delta1(i))));
        end

        if mu1 < mu2
            result(i) = 0;
        else
            result(i) = 1;
        end
    end

end