%% About 
% Script to visualize maximum visual receptive field (RF) around a taxel for peripersonal space (PPS) representations
% Author: Matej Hoffmann, matej.hoffmann@iit.it
clear;

Z_MAX = 0.2; % max extent of RF in z (normal to taxel)

APERTURE_DEG = 80; %the spherical sector / cone opening angle or aperture
APERTURE_RAD = (APERTURE_DEG / 360) * 2 * pi;

res = 40; % resolution

u = linspace(0,Z_MAX,res);
azimuth = linspace(0,2*pi,res);

%% CONE
%global_r = u(end) * tan(APERTURE_RAD / 2); % at base (maximum)

x=[]; y=[]; z=[];


for i=1:length(u)
    for j=1:(length(azimuth)-1)
        z = [z; u(i)];        
        r = u(i) * tan(APERTURE_RAD / 2); 
        x = [x; r*cos(azimuth(j)) ]; 
        y = [y; r*sin(azimuth(j)) ];
        %x = [x; (u(i) / Z_MAX) *global_r*cos(thetas(j)) ]; 
        %y = [y; (u(i) / Z_MAX) *global_r*sin(thetas(j)) ];
    end    
end


f1 = figure(1);
clf(f1);
set(f1,'name','RF as a cone');
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

view(3);
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

%% SPHERICAL SECTOR


f2 = figure(2);
clf(f2);
set(f2,'name','RF as a spherical sector');
hold on;
 
%polar_angle = linspace(-APERTURE_RAD/2,APERTURE_RAD/2,res); 
polar_angle = linspace(pi/2-APERTURE_RAD/2,pi/2+APERTURE_RAD/2,res); % in matlab: elevation is angular displacement in radians from the x-y plane
% also called co-latitude, zenith angle, normal angle, or inclination angle.
[theta,phi] = meshgrid(azimuth,polar_angle);
 
for radius = 0.0:0.01:Z_MAX
    [xs,ys,zs] = sph2cart(theta,phi,radius);
    h_surface = surf(xs,ys,zs);
    set(h_surface, 'FaceColor',[0.3 0.3 0.3], 'FaceAlpha',0.5); %'EdgeAlpha', 0);
    %plot3(xs,ys,zs);
    %set(h(i),'FaceAlpha',transparent);
    
end
axis equal;
grid on;
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');
hold off;

view(3);

% 
% % something from matlab central: http://it.mathworks.com/matlabcentral/newsreader/view_thread/280431
% r = 5;
% [theta,phi] = meshgrid(linspace(0,.4*pi,32),linspace(-pi/2,pi/2,32));
% x1 = r.*cos(theta).*cos(phi);
% y1 = r.*sin(theta).*cos(phi);
% z1 = r.*sin(phi);
% theta = 0;
% [r,phi] = meshgrid(linspace(0,5,32),linspace(-pi/2,pi/2,32));
% x2 = r.*cos(theta).*cos(phi);
% y2 = r.*sin(theta).*cos(phi);
% z2 = r.*sin(phi);
% theta = .4*pi;
% [r,phi] = meshgrid(linspace(0,5,32),linspace(-pi/2,pi/2,32));
% x3 = r.*cos(theta).*cos(phi);
% y3 = r.*sin(theta).*cos(phi);
% z3 = r.*sin(phi);
% x = [x1;x2;x3];
% y = [y1;y2;y3];
% z = [z1;z2;z3];
% surf(x,y,z)
% axis square



