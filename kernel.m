function [ K ] = kernel( type, Xi, Xj )
	if strcmp(type,'RBF')
		sigma=1;
		K=exp(norm(Xi-Xj)/(2*sigma^2));
	else if strcmp(type,'Poly')
		p=3;
		K=(1+Xi*transpose(Xj))^p;
	end
end