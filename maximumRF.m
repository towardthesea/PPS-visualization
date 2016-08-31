%% About 
% Script to visualize maximum visual receptive field (RF) around a taxel for peripersonal space (PPS) representations
% Author: Matej Hoffmann, matej.hoffmann@iit.it
clear;

Z_MAX = 0.2; % max extent of RF in z (normal to taxel)

APERTURE_DEG = 80; %the cone opening angle or aperture
APERTURE_RAD = (APERTURE_DEG / 360) * 2 * pi;

u = linspace(0,Z_MAX,40);
%global_r = u(end) * tan(APERTURE_RAD / 2); % at base (maximum)
thetas = linspace(0,2*pi,40);
x=[]; y=[]; z=[];


for i=1:length(u)
    for j=1:(length(thetas)-1)
        z = [z; u(i)];        
        r = u(i) * tan(APERTURE_RAD / 2); 
        x = [x; r*cos(thetas(j)) ]; 
        y = [y; r*sin(thetas(j)) ];
        %x = [x; (u(i) / Z_MAX) *global_r*cos(thetas(j)) ]; 
        %y = [y; (u(i) / Z_MAX) *global_r*sin(thetas(j)) ];
    end    
end


f1 = figure(1);
clf(f1);
hold on;
scatter3(x,y,z);
%line([0 r],[0 0],[0 Z_MAX] );
%plot3(u(2) * tan(APERTURE_RAD / 2),0,u(2),'x','MarkerSize',20);

axis equal;
grid on;
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');
hold off;

%plot3(x,y,z,'o');

% f2 = figure(2);
% clf(f2);
%     subplot(3,1,1);
%         plot(x);
%         title('x');
%     subplot(3,1,2);
%         plot(y);
%         title('y');
%     subplot(3,1,3);
%         plot(z);
%         title('z');
% 
% f3 = figure(3);
% clf(f3);
%     subplot(3,1,1);
%         plot(thetas);
%         title('thetas (rad)');
%     subplot(3,1,2);
%         plot(cos(thetas));
%         title('cos(thetas)');
%     subplot(3,1,3);
%         plot(sin(thetas));
%         title('sin(thetas)');

% code plotting truncated cone as a spiral 
%from http://it.mathworks.com/matlabcentral/answers/39082-truncated-cone-plot
% t = 30:0.1:100;
% az = 0.1;
% z = az*t;
% r0 = 10000;
% ar = -1;
% r = r0 + r0*t;
% at = 0.05;
% theta = at*t;
% x = r .* cos(t);
% y = r .* sin(t);
% figure
% plot3(x,y,z,'.-')


