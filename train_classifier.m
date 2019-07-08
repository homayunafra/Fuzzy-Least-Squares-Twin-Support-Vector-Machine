function [struct] = train_classifier(MembershipA, MembershipB, ClassA, ClassB, type, kernel, c, sigma)
	fuzzy = 0;
	if (fuzzy == 1)
		[m1,n] = size(ClassA);
		[m2,n] = size(ClassB);
		[A IDX] = fcm([ClassA;ClassB], 2);
		[v IndB] = min(IDX(:,1));
		[v IndA] = max(IDX(:,1));
		ClassBConstraint = -IDX(IndB,1:m2);
		ClassAConstraint = -IDX(IndA,m2+1:m2+m1);
		k = [ClassAConstraint,ClassBConstraint]';
	end
	if strcmp(type,'flstsvm')
		struct = flstsvm(MembershipA, MembershipB, ClassA, ClassB, c);
	else if strcmp(type,'lstsvm')
		struct = lstsvm(ClassA, ClassB, c);
	end
end