function [result] = test_classification(classifier_struct, testdata)
	[d n] = size(testdata);

	w1 = classifier_struct.W1;
	b1 = classifier_struct.B1;
	c1 = classifier_struct.C1;
	d1 = classifier_struct.D1;
	w2 = classifier_struct.W2;
	b2 = classifier_struct.B2;
	c2 = classifier_struct.C2;
	d2 = classifier_struct.D2;

	delta1 = abs(testdata*w1+b1);
	gamma1 = abs(testdata*(w1+c1)+b1+d1);

	delta2=abs(testdata*w2+b2);
	gamma2=abs(testdata*(w2+c2)+d2);

	for i=1:size(testdata)
		gamma1(i) = max([abs(testdata(i,:)*(w1+c1)+b1+d1), abs(testdata(i,:)*(w1-c1)+b1+d1), abs(testdata(i,:)*(w1+c1)+b1-d1), abs(testdata(i,:)*(w1-c1)+b1-d1)] );
		gamma2(i) = max([abs(testdata(i,:)*(w2+c2)+b2+d2), abs(testdata(i,:)*(w2-c2)+b2+d2), abs(testdata(i,:)*(w2+c2)+b2-d2), abs(testdata(i,:)*(w2-c2)+b2-d2)] );
	end

	for i = 1:d
		mu1 = 1;
		mu2 = 1;
		if delta1(i) >= gamma1(i) && delta2(i) >= gamma2(i)
			mu1 = (1-((delta1(i)+ gamma1(i))/(delta1(i)+ gamma1(i)+delta2(i)+gamma2(i))));
			mu2 = (1-((delta2(i)+ gamma2(i))/(delta2(i)+ gamma2(i)+delta1(i)+gamma1(i))));
		else if delta1(i) < gamma1(i) && delta2(i) >= gamma2(i)
			mu1 = (1-((delta1(i))/(delta1(i)+delta2(i)+gamma2(i))));
			mu2 = (1-((delta2(i)+ gamma2(i))/(delta2(i)+ gamma2(i)+delta1(i))));
		else if delta1(i) >= gamma1(i) && delta2(i) < gamma2(i)
			mu1 = (1-((delta1(i)+ gamma1(i))/(delta1(i)+ gamma1(i)+delta2(i))));
			mu2 = (1-((delta2(i))/(delta2(i)+delta1(i)+gamma1(i))));
		else if delta1(i) < gamma1(i) && delta2(i) < gamma2(i)
			mu1 = (1-((delta1(i))/(delta1(i)+delta2(i))));
			mu2 = (1-((delta2(i))/(delta2(i)+delta1(i))));
		end
		
		if mu1 < mu2
			result(i) = 0;
		else
			result(i) = 1;
		end
	end

	% result=(distancA<distancB);

end