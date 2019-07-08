function [struct] = flstsvm(membershipA, membershipB, classA, classB, c, sigma)

	%------------------------------------------------------------------

	sigma = 10e-6;
	% sigma =0;
	[m1,n1] = size(classA);
	[m2,n2] = size(classB);

	%--------------------DTWSVM1-----------------------------
	P = classA;
	Pp = transpose(classA);
	N = classB;
	Np = transpose(classB);
	muA = membershipA;
	muAp = transpose(membershipA);
	muB = membershipB;
	muBp = transpose(membershipB);
	eA = ones(m1,1);
	eB = ones(m2,1);
	eAp = transpose(eA);
	eBp = transpose(eB);
	c1 = c;
	c2 = c;
	M = 1;

	E11 = (repmat(muBp,n1,1).*Np)*(repmat(muB,1,n1).*N)+ (1/c1)*Pp*P;
	E12 = (repmat(muBp,n1,1).*Np)*(muB.*eB)+(1/c1)*Pp*eA;
	E13 = (1/c1)*Pp*P;
	E14 = (1/c1)*Pp*eA;
	
	E21 = (muBp.*eBp)*(repmat(muB,1,n1).*N)+ (1/c1)*eAp*P;
	E22 = (muBp.*eBp)*(muB.*eB)+ (1/c1)*m1;
	E23 = (1/c1)*eAp*P;
	E24 = (1/c1)*m1;
	
	E31 = Pp*P
	E32 = Pp*eA;
	E33 = M + Pp*P;
	E34 = Pp*eA;
	
	E41 = eAp*P;
	E42 = m1;
	E43 = eAp*P;
	E44 = m1;
	
	E = [E11, E12, E13, E14
		E21, E22, E23, E24
		E31, E32, E33, E34
		E41, E42, E43, E44];
	
	wwww = inv(E);
	
	E11 = (repmat(muBp,n1,1).*Np)*(muB.*eB);
	E12 = (muBp.*eBp)*(muB.*eB);
	E13 = 0*Pp*eA;
	E14 = M;
	
	U = E\[E11;E12 ; E13; E14];
	w1 = U(1:n1,:);
	b1 = U(n1+1,:);
	c1 = U(n1+2:end-1,:);
	d1 = U(end,:);
	
	% E= [classA ones(m1,1)];
	% F = [classB ones(m2,1)];
	% U1=-1*inv(F'*F+(1/(c*1))*E'*E+sigma*speye(n+1))*(F')*1*ones(m2,1);
	% 
	% w1= U1(1:n,:);
	% b1=U1(n+1,:);
	
	%--------------------------DTWSVM2---------------------
	
	% U2=1*inv(E'*E+(1/(c))*F'*F+sigma*speye(n+1))*E'*1*ones(m1,1);
	% 
	% w2= U2(1:n,:);
	% b2=U2(n+1,:);
	
	E11=(repmat(muAp,n2,1).*Pp)*(repmat(muA,1,n2).*P)+ (1/c2)*Np*N;
	E12=(repmat(muAp,n2,1).*Pp)*(muA.*eA)+(1/c2)*Np*eB;
	E13=(1/c2)*Np*N;
	E14=(1/c2)*Np*eB;
	
	E21=(muAp.*eAp)*(repmat(muA,1,n2).*P)+ (1/c2)*eBp*N;
	E22=(muAp.*eAp)*(muA.*eA)+ (1/c2)*m2;
	E23=(1/c2)*eBp*N;
	E24=(1/c2)*m2;
	
	E31 = Np*N
	E32 = Np*eB;
	E33 = M + Np*N;
	E34 = Np*eB;
	
	E41 = eBp*N;
	E42 = m2;
	E43 = eBp*N;
	E44 = m2;
	
	E = [E11, E12, E13, E14
		E21, E22, E23, E24
		E31, E32, E33, E34
		E41, E42, E43, E44];
	
	wwww = inv(E);
	E11 = (repmat(muAp,n2,1).*Pp)*(muA.*eA);
	E12 = (muAp.*eAp)*(muA.*eA);
	E13 = 0*Np*eB;
	E14 = M;
	
	U = E\[E11;E12 ; E13; E14];
	w2 = U(1:n1,:);
	b2 = U(n1+1,:);
	c2 = U(n1+2:end-1,:);
	d2 = U(end,:);
	
	[struct2] = FLSTSVM(classA, classB, c, sigma)
	
	%-------------------------Testing-----------------------------------------
	struct.W1 = struct2.W1;
	struct.B1 = struct2.B1;
	struct.C1 = c1;
	struct.D1 = d1;
	struct.W2 = struct2.W2;
	struct.B2 = struct2.B2;
	struct.C2 = c2;
	struct.D2 = d2;
	
end