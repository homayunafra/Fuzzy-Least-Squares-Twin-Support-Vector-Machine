function [Correctrate ErrorRate] = call_classifier(memberships, dataSet, classes, Tsvm_type, c, sigma)
	twoclass = 1;
	%loop must be modified
	KfoldNumber=2;
	
	indices = crossvalind('Kfold', classes, KfoldNumber);
	classifier_cp = classperf(classes);
	for i = 1:KfoldNumber-1
		test = (indices == i); train = ~test;
		if(twoclass)
			ClassA = dataSet(classes == 2 & train == 1,:);
			ClassB = dataSet(classes == 1 & train == 1,:);
			MembershipA = memberships(classes == 2 & train == 1,:);
			MembershipB = memberships(classes == 1 & train == 1,:);
			testdata = dataSet(test==1,:);
			labeltest = classes(indices == 1);
			[classifer_struct] = train_classifier(MembershipA, MembershipB, ClassA, ClassB, Tsvm_type,'kernel', c, sigma);
			[resultClass] = 1 + test_classification(classifer_struct, testdata);
			classperf(classifier_cp, resultClass, test);
			Correctrate(i) = classifier_cp.Correctrate
		else
			allTsvmStruct = TsvmVotingTraining(dataSet, classes, train, Tsvm_type, c);
			[confusionMatrix resultClass resultInplaceClass] = TsvmVotingTesting(dataSet, classes, test, allTsvmStruct);   
			lstBsvm_allconfusionMatrix(i,:,:) = confusionMatrix;
			classperf(classifier_cp,resultClass,test);
			Correctrate(i) = classifier_cp.Correctrate;
		
		save 'lstBsvm_allconfusionMatrix' lstBsvm_allconfusionMatrix;
		save LSTsvm_allResultClass;
		save classifier_cp;

		end
	end
end