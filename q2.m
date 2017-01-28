function [val] = q2(data,th)

    clc;
    m = size(data,1);%No of images
    n = size(data,2);%No of observers
    x = [0:0.1:5];
    MOS = mean(data,2);
    
    for i = 1:length(th)
        PDU = (sum(data<th(i),2)*100)/n;
        figure;
        scatter(MOS,PDU);
        [b] = regress(PDU,[MOS ones(m,1)]);
        %regression(PDU,MOS,'one')
        hold on;
        plot(x,b(1)*x + b(2),'r');
        title(num2str(th(i)', 'Linear Model th = %-d'),'FontSize',25);
        set(gca,'FontSize',25)
        figure;
        err  = PDU - b(1)*MOS - b(2);
        plot(MOS, abs(err),'*');
        sum(err .* err)/m
    end
   
end