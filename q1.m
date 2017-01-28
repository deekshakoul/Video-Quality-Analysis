function [val] = q1(data,th)
    clc;
    m = size(data,1);%No of images
    n = size(data,2);%No of observers
    
    MOS = mean(data,2);
    
    for i = 1:length(th)
        PDU = (sum(data<th(i),2)*100)/n;
        size(PDU);
        hold on;
        scatter(MOS,PDU,100,'filled','MarkerEdgeColor',de2bi(i,3));
        c = corrcoef(MOS,PDU);
        co = c(1,2)
    end
   
    xlabel('MOS','FontSize',22);
    ylabel('PDU','FontSize',22);
    set(gca,'FontSize',22);
    legendCell = cellstr(num2str(th', 'th=%-d'));
    legend(legendCell);
    title(num2str(c(1,2)', 'Correlation Coefficient=%-d'),'FontSize',22);
end