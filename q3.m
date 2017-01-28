q3function [ft] = q3(data,th)
    clc;
    m = size(data,1);%No of images
    n = size(data,2);%No of observers
    
    MOS = mean(data,2);
    PDU = (sum(data<th,2)*100)/n;

   %Linear Regression
     [b_lin] = regress(PDU,[MOS ones(m,1)]);
     PDU_lin = b_lin(1)*MOS + b_lin(2);
     err_lin = sum((PDU-PDU_lin).^2)/m;
     
     %Logistic
     x0 = [2,1,3,50];
     b_log = fminsearch(@(x)objfn(MOS,PDU,x),x0);
     PDU_log = b_log(1)*((1/2)-(1./(1 + exp(b_log(2)*(MOS-b_log(3))))))+b_log(4);
     err_log = sum((PDU-PDU_log).^2)/m;
     
     %Gaussian
     f = fit(MOS,PDU,'gauss1')
     b = coeffvalues(f);
     PDU_gauss = (b(1) * exp(-((MOS-b(2))/b(3)).^2));
     err_gauss = sum((PDU - PDU_gauss).^2)/m;
     
     
     [f1, fcurv] = FTest(err_lin,err_log,n-2,n-4,0.05)
     [f2, fcurv] = FTest(err_gauss,err_log,n-3,n-4,0.05)
     [f3, fcurv] = FTest(err_lin,err_gauss,n-2,n-3,0.05)
     
     ft = [f1 f2 f3 fcurv];
end

function[Fobs Fcurve] = FTest(ss1,ss2,df1,df2,alpha)
Fobs = ((ss1-ss2)*df2)/(ss2*(df1-df2));
Fcurve = icdf('F',1 - alpha/2,df1-df2,df2);
end

function f = objfn(MOS,PDU,x)
    val = x(1)*((1/2)-(1./(1 + exp(x(2)*(MOS-x(3))))))+x(4);
    err = PDU  - val;
    f = sum(err .* err);
end