function q5(data1,data2,th)

clc;
x = 1:0.1:5;
m1 = size(data1,1);
m2 = size(data2,1);

n1 = size(data1,2);
n2 = size(data2,2);

MOS1 = mean(data1,2);
MOS2 = mean(data2,2);

for i = 1:length(th)
    th(i)
     PDU1 = (sum(data1<th(i),2)*100)/n1;
     PDU2 = (sum(data2<th(i),2)*100)/n2;
     
     scatter(MOS2,PDU2);
     
     %Linear Regression
     [b_lin] = regress(PDU1,[MOS1 ones(m1,1)]);
     PDU2_lin = b_lin(1)*MOS2 + b_lin(2);
     err_lin = sum((PDU2-PDU2_lin).^2)/m2
     
     hold on;
     %plot(MOS2,PDU2_lin,'r');
     plot(x,b_lin(1)*x + b_lin(2),'r','LineWidth',2);
     %Logistic
     x0 = [2,1,3,50];
     b_log = fminsearch(@(x)objfn(MOS1,PDU1,x),x0);
     PDU2_log = b_log(1)*((1/2)-(1./(1 + exp(b_log(2)*(MOS2-b_log(3))))))+b_log(4);
     err_log = sum((PDU2-PDU2_log).^2)/m2
     
     hold on;
     %plot(MOS2,PDU2_log,'y*');
     plot(x,b_log(1)*((1/2)-(1./(1 + exp(b_log(2)*(x-b_log(3))))))+b_log(4),'m','LineWidth',2);
     
     %Gaussian
     f = fit(MOS1,PDU1,'gauss1')
     b = coeffvalues(f);
     PDU2_gauss = (b(1) * exp(-((MOS2-b(2))/b(3)).^2));
     err_gauss = sum((PDU2 - PDU2_gauss).^2)/m2
     plot(x,(b(1) * exp(-((x-b(2))/b(3)).^2)),'g','LineWidth',2);
     
     legend('Data',num2str(err_lin', 'Linear (MSE = %-d)'),num2str(err_log', 'Logistic(MSE = %-d)'),num2str(err_gauss', 'Gaussian (MSE = %-d)'));
     set(gca,'FontSize',20);
     xlabel('MOS','FontSize',25);
     ylabel('PDU','FontSize',25);
end

end


function f = objfn(MOS,PDU,x)
    val = x(1)*((1/2)-(1./(1 + exp(x(2)*(MOS-x(3))))))+x(4);
    err = PDU  - val;
    f = sum(err .* err);
end