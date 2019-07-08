function [struct] = lstsvm(classA, classB, c, sigma)
	%------------------------------------------------------------------
	sigma = 10e-6;
	% sigma =0;
	[m1,n] = size(classA);
	[m2,n] = size(classB);

	%--------------------DTWSVM1-----------------------------

	E = [classA ones(m1,1)];
	F = [classB ones(m2,1)];
	U1 = -1*inv(F'*F+(1/(c*1))*E'*E+sigma*speye(n+1))*(F')*1*ones(m2,1);

	w1 = U1(1:n,:);
	b1 = U1(n+1,:);

	%--------------------------DTWSVM2---------------------

	U2 = 1*inv(E'*E+(1/(c))*F'*F+sigma*speye(n+1))*E'*1*ones(m1,1);

	w2 = U2(1:n,:);
	b2 = U2(n+1,:);


	%-------------------------Testing-----------------------------------------
	struct.W1 = w1;
	struct.B1 = b1;
	struct.W2 = w2;
	struct.B2 = b2;

end