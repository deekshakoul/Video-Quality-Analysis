function [val] = q4(data,th)
    clc;
    m = size(data,1);%No of images
    n = size(data,2);%No of observers
    sim =1000;
    
    MOS = mean(data,2);
    PDU = (sum(data<th,2)*100)/n;
    alpha = 0.05;
    
      %Linear Regression
     [b_lin] = regress(PDU,[MOS ones(m,1)]);
     PDU_lin = b_lin(1)*MOS + b_lin(2);
     %err_lin = sum((PDU-PDU_lin).^2)/m
     
     %Logistic
     x0 = [2,1,3,50];
     b_log = fminsearch(@(x)objfn(MOS,PDU,x),x0);
     PDU_log = b_log(1)*((1/2)-(1./(1 + exp(b_log(2)*(MOS-b_log(3))))))+b_log(4);
     %err_log = sum((PDU-PDU_log).^2)/m2
     
     %Gaussian
     f = fit(MOS,PDU,'gauss1')
     b = coeffvalues(f);
     PDU_gauss = (b(1) * exp(-((MOS-b(2))/b(3)).^2));
    % err_gauss = sum((PDU - PDU_gauss).^2)/m2
    
    val1 = zeros(1,sim);
    val2 = zeros(1,sim);
    val3 = zeros(1,sim);
    
    for j = 1:sim
        samples = randi(m,1,m);
        val1(j) =  sum((PDU(samples)-PDU_lin(samples)).^2)/m;
        val2(j) =  sum((PDU(samples)-PDU_log(samples)).^2)/m;
        val3(j) =  sum((PDU(samples)-PDU_gauss(samples)).^2)/m;        
    end
    CI1 = prctile(val1,[100*alpha/2,100*(1-alpha/2)])
    CI2 = prctile(val2,[100*alpha/2,100*(1-alpha/2)])
    CI3 = prctile(val3,[100*alpha/2,100*(1-alpha/2)])
    
    figure;
    errorbar(1,mean(CI1),(CI1(2)-CI1(1))/2,'MarkerSize',100,'LineWidth',2);
    hold on;
    errorbar(3,mean(CI2),(CI2(2)-CI2(1))/2,'r','MarkerSize',100,'LineWidth',2);
    hold on;
    errorbar(5,mean(CI3),(CI3(2)-CI3(1))/2,'g','MarkerSize',100,'LineWidth',2);
    title('CIs for three models','FontSize',22);
    legend('Linear','Logistic','Gaussian');
    set(gca,'FontSize',22);
end

function f = objfn(MOS,PDU,x)
    val = x(1)*((1/2)-(1./(1 + exp(x(2)*(MOS-x(3))))))+x(4);
    err = PDU  - val;
    f = sum(err .* err);
end