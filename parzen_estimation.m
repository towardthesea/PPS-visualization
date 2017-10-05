%% About 
% Function to calculate the parzen window estimation of activation for a 
% skin taxel
% range: vector of sample of distance to taxel
% values: vector of raw activation
% sigm: sigma of parzen window
% color: color
% titleStr: string of the title of the figure
% varargin(1): to display figure or not


% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com
% Thanks to the help of Alessandro Roncone for this function

%%
function [res, x] = parzen_estimation(range,values,sigm,color,titleStr,varargin)
    H = values;
    nSampl = length(range);
    binWidth = (range(end)-range(1))/nSampl;
    x = linspace(range(1),range(end),10*nSampl);    % Change to add resolution 
    p = zeros(1,length(x));
    for i = 1:length(x)
        p(i)=0;
        for j = 1:nSampl
            x_0 = range(1)+(j-1)*binWidth + binWidth/2;
            if H(j) > 0 
                p(i) = p(i) + H(j)*(1/(sqrt(2*pi)*sigm))*exp(-0.5*(x(i)-x_0)*(x(i)-x_0)/(sigm*sigm));
            end
        end
    end

    res = zeros(1,length(x));
    res(p>0) = p(p>0);
    res = res*1/max(res);           % Scale it to 1

    bC = zeros(1,length(H));
    bC(H>0)=H(H>0);
    bC=bC*1/max(bC);                % Scale it to 1
    bX =range; %bX(end)=[];
    size(bX);
    size(bC);

    plotFigure = 1;
    plotFigure_modulated = 0;
    RF = [-0.1 0.2];
    if (~isempty(varargin))
        if (length(varargin)>=3)
            plotFigure = varargin{1};
            RF = varargin{2};
            plotFigure_modulated = varargin{3};
        elseif (length(varargin)>=2)
            plotFigure = varargin{1};
            RF = varargin{2};
        elseif (length(varargin)>=1)
            plotFigure = varargin{1};
        end
    end
    if (plotFigure)
        hold on;
        bar(bX,bC,'g');
        title(titleStr);
        plot(x,res,'LineWidth',2,'color',color);
        if (plotFigure_modulated)
            plot(x,0.5*res,'b--','LineWidth',4);%,'color',[1 0.5 0]);
        end
        xtick = [RF(1):0.1:0,0:0.1:RF(2)];
        set(gca,'YTick',[0:0.2:1],'XTick',xtick,'FontSize',40);
        xlabel('Distance (m)','FontSize',40);
        ylabel('Activation','FontSize',40);
        axis([range(1)-.01 range(end)+.01 0 1]);
        hold off;
    end
    
    
end