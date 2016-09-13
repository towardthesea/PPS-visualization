% About 
% Script to visualize maximum visual receptive field (RF) around a taxel for peripersonal space (PPS) representations
% Author: Matej Hoffmann, matej.hoffmann@iit.it

%% INIT

clear;

PLOT_NEGATIVE_RF = true;
PLOT_PROJECTIONS = true;
TEST_INSIDE_RF = true;
SAVE_FIGS = false;

Z_MAX = 0.2; % max extent of RF in z (normal to taxel), meters
Z_NEGATIVE_MAX = -0.1;

APERTURE_DEG = 100; %the spherical sector / cone opening angle or aperture
APERTURE_RAD = (APERTURE_DEG / 360) * 2 * pi;

res = 20; % resolution

u = linspace(0,Z_MAX,res);
azimuth = linspace(0,2*pi,res);

DESIRED_RADIUS_XY_AT_APEX = 0.07; % 0.05; % meters; we don't want the spherical sector to start at the apex, where it would have 0 volume
%but we want to truncate it such that it starts at the height with this radius;

CONE_HEIGHT_AT_OFFSET = DESIRED_RADIUS_XY_AT_APEX / tan(APERTURE_RAD/2);    % tan(APERTURE_RAD/2) = radius_xy / z_offset; 
%Z_OFFSET = 0;
SPHERE_RADIUS_AT_OFFSET = DESIRED_RADIUS_XY_AT_APEX / sin(APERTURE_RAD/2);    % cos(APERTURE_RAD/2) = radius_xy / sphere_radius;
% here the radius of the sphere will at the same time be used as the
% z-offset - with the radius then equal to cone height + spherical cap height

if TEST_INSIDE_RF
    SAMPLE_MAX_ALL_DIM = 0.2;
    SAMPLE_MIN_ALL_DIM = -0.2;
end

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
 
%polar_angle = linspace(-APERTURE_RAD/2,APERTURE_RAD/2,res); 
polar_angle = linspace(pi/2-APERTURE_RAD/2,pi/2+APERTURE_RAD/2,res); % in matlab: elevation is angular displacement in radians from the x-y plane
% also called co-latitude, zenith angle, normal angle, or inclination angle.
[theta,phi] = meshgrid(azimuth,polar_angle);
 
max_radius_z = Z_MAX+CONE_HEIGHT_AT_OFFSET;
radius_z = linspace(SPHERE_RADIUS_AT_OFFSET,max_radius_z,res);


f2 = figure(2);
clf(f2);
set(f2,'name','RF as a spherical sector');
hold on;

%view(3);
az = 0; el = 0;
view(az, el);


for i=1:length(radius_z)
    [xs,ys,zs] = sph2cart(theta,phi,radius_z(i));
    zs = zs - CONE_HEIGHT_AT_OFFSET;
    h_surface = surf(xs,ys,zs);
    %plot3(xs,ys,zs);
    set(h_surface, 'FaceColor',[0.9 0.9 0.9], 'FaceAlpha',0.5); %'EdgeAlpha', 0);
end


if PLOT_NEGATIVE_RF
    max_radius_z_neg = abs(Z_NEGATIVE_MAX)+CONE_HEIGHT_AT_OFFSET;
    radius_z_neg = linspace(SPHERE_RADIUS_AT_OFFSET,max_radius_z_neg,res);
    for i=1:length(radius_z)
        [xs,ys,zs] = sph2cart(theta,phi,radius_z_neg(i));
        zs = zs - CONE_HEIGHT_AT_OFFSET;
        zs = zs * -1;
        h_surface = surf(xs,ys,zs);
        set(h_surface, 'FaceColor',[0.9 0.9 0.9], 'FaceAlpha',0.5); %'EdgeAlpha', 0);
        %plot3(xs,ys,zs);
    end
end
    

plot3(0,0,0,'o','MarkerSize',10,'MarkerFaceColor','blue');
grid on;
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');
if PLOT_NEGATIVE_RF
    zlim([Z_NEGATIVE_MAX-0.05 Z_MAX+0.05]);
else
    zlim([-0.02 Z_MAX+0.05]);
end
axis equal;


if TEST_INSIDE_RF
    samples = [];
    samples_x0 = [];
    samples_y0 = [];
    samples_z0 = [];
    for i=SAMPLE_MIN_ALL_DIM:0.02:SAMPLE_MAX_ALL_DIM
        for j=SAMPLE_MIN_ALL_DIM:0.02:SAMPLE_MAX_ALL_DIM
            for k=Z_NEGATIVE_MAX-0.04:0.02:Z_MAX+0.04
                samples= [samples ; i j k];
                if PLOT_PROJECTIONS
                    if i==0
                       samples_x0 = [samples_x0 ; i j k];
                    end
                    if j==0
                       samples_y0 = [samples_y0 ; i j k];
                    end
                    if (k>-0.00000001 && k<0.00000001)
                       samples_z0 = [samples_z0 ; i j k];
                    end
                end
            end
        end
    end
    
    sphericalSectorCenter = [0,0,0-CONE_HEIGHT_AT_OFFSET];
    plot3(sphericalSectorCenter(1),sphericalSectorCenter(2),sphericalSectorCenter(3),'d','MarkerSize',7,'MarkerFaceColor','blue');
    
    sphericalSectorNegativeCenter = [0,0,CONE_HEIGHT_AT_OFFSET];
    plot3(sphericalSectorNegativeCenter(1),sphericalSectorNegativeCenter(2),sphericalSectorNegativeCenter(3),'d','MarkerSize',7,'MarkerFaceColor','blue');
    
  
   for l=1:size(samples,1)
       if(samples(l,3) >= 0)
           if (samples(l,3)<=Z_MAX)
             distance = sqrt( (samples(l,1)-sphericalSectorCenter(1))^2 + (samples(l,2)-sphericalSectorCenter(2))^2 + (samples(l,3)-sphericalSectorCenter(3))^2);
             if distance<=max_radius_z
                a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + samples(l,3));
                if( (abs(samples(l,1)) <= a) && (abs(samples(l,2)) <= a) )
                    plot3(samples(l,1),samples(l,2),samples(l,3),'og','MarkerSize',5,'MarkerFaceColor','green');
                else
                    plot3(samples(l,1),samples(l,2),samples(l,3),'xr','MarkerSize',5);
                end
             else
                plot3(samples(l,1),samples(l,2),samples(l,3),'xr','MarkerSize',5);
             end
           else
             plot3(samples(l,1),samples(l,2),samples(l,3),'xr','MarkerSize',5);
           end
       else
         if (samples(l,3)>=Z_NEGATIVE_MAX)
             distance = sqrt( (samples(l,1)-sphericalSectorNegativeCenter(1))^2 + (samples(l,2)-sphericalSectorNegativeCenter(2))^2 + (samples(l,3)-sphericalSectorNegativeCenter(3))^2);
             if distance<=max_radius_z_neg
                a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + abs(samples(l,3)));
                if( (abs(samples(l,1)) <= a) && (abs(samples(l,2)) <= a) )
                    plot3(samples(l,1),samples(l,2),samples(l,3),'og','MarkerSize',5,'MarkerFaceColor','green');
                else
                    plot3(samples(l,1),samples(l,2),samples(l,3),'xr','MarkerSize',5);
                end
             else
                plot3(samples(l,1),samples(l,2),samples(l,3),'xr','MarkerSize',5);
             end
         else
             plot3(samples(l,1),samples(l,2),samples(l,3),'xr','MarkerSize',5);
         end
       end 
    end
end   
    
%% PLOT projections
    
  if (TEST_INSIDE_RF && PLOT_PROJECTIONS)

       % y=0 plane
       f3 = figure(3);
       clf(f3);
       set(f3,'name','RF as a spherical sector - y=0 projection');
       hold on; 
       for l=1:size(samples_y0,1)
           if(samples_y0(l,3) >= 0)
               if (samples_y0(l,3)<=Z_MAX)
                 distance = sqrt( (samples_y0(l,1)-sphericalSectorCenter(1))^2 + (samples_y0(l,2)-sphericalSectorCenter(2))^2 + (samples_y0(l,3)-sphericalSectorCenter(3))^2);
                 if distance<=max_radius_z
                    a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + samples_y0(l,3));
                    if( (abs(samples_y0(l,1)) <= a) && (abs(samples_y0(l,2)) <= a) )
                        plot(samples_y0(l,1),samples_y0(l,3),'og','MarkerSize',5,'MarkerFaceColor','green');
                    else
                        plot(samples_y0(l,1),samples_y0(l,3),'xr','MarkerSize',5);
                    end
                 else
                    plot(samples_y0(l,1),samples_y0(l,3),'xr','MarkerSize',5);
                 end
               else
                 plot(samples_y0(l,1),samples_y0(l,3),'xr','MarkerSize',5);
               end
           else
             if (samples_y0(l,3)>=Z_NEGATIVE_MAX)
                distance = sqrt( (samples_y0(l,1)-sphericalSectorNegativeCenter(1))^2 + (samples_y0(l,2)-sphericalSectorNegativeCenter(2))^2 + (samples_y0(l,3)-sphericalSectorNegativeCenter(3))^2);
                if distance<=max_radius_z_neg
                    a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + abs(samples_y0(l,3)));
                    if( (abs(samples_y0(l,1)) <= a) && (abs(samples_y0(l,2)) <= a) )
                        plot(samples_y0(l,1),samples_y0(l,3),'og','MarkerSize',5,'MarkerFaceColor','green');
                    else
                        plot(samples_y0(l,1),samples_y0(l,3),'xr','MarkerSize',5);
                    end
                else
                    plot(samples_y0(l,1),samples_y0(l,3),'xr','MarkerSize',5);
                end
             else
                plot(samples_y0(l,1),samples_y0(l,3),'xr','MarkerSize',5);
             end
           end
       end 
       plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','blue');
       plot(sphericalSectorCenter(1),sphericalSectorCenter(3),'d','MarkerSize',7,'MarkerFaceColor','blue');
       plot(sphericalSectorNegativeCenter(1),sphericalSectorNegativeCenter(3),'d','MarkerSize',7,'MarkerFaceColor','blue');
       grid on;
       xlabel('x (m)');
       ylabel('z (m)');
       axis equal;

       
       % x=0 plane
       f4 = figure(4);
       clf(f4);
       set(f4,'name','RF as a spherical sector - x=0 projection');
       hold on; 
       for l=1:size(samples_x0,1)
           if(samples_y0(l,3) >= 0)
               if (samples_x0(l,3)<=Z_MAX)
                 distance = sqrt( (samples_x0(l,1)-sphericalSectorCenter(1))^2 + (samples_x0(l,2)-sphericalSectorCenter(2))^2 + (samples_x0(l,3)-sphericalSectorCenter(3))^2);
                 if distance<=max_radius_z
                    a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + samples_x0(l,3));
                    if( (abs(samples_x0(l,1)) < a) && (abs(samples_x0(l,2)) < a) )
                        plot(samples_x0(l,2),samples_x0(l,3),'og','MarkerSize',5,'MarkerFaceColor','green');
                    else
                        plot(samples_x0(l,2),samples_x0(l,3),'xr','MarkerSize',5);
                    end
                 else
                    plot(samples_x0(l,2),samples_x0(l,3),'xr','MarkerSize',5);
                 end
               else
                 plot(samples_x0(l,2),samples_x0(l,3),'xr','MarkerSize',5);
               end
           else
             if (samples_x0(l,3)>=Z_NEGATIVE_MAX)
                distance = sqrt( (samples_x0(l,1)-sphericalSectorNegativeCenter(1))^2 + (samples_x0(l,2)-sphericalSectorNegativeCenter(2))^2 + (samples_x0(l,3)-sphericalSectorNegativeCenter(3))^2);
                if distance<=max_radius_z_neg
                    a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + abs(samples_x0(l,3)));
                    if( (abs(samples_x0(l,1)) < a) && (abs(samples_x0(l,2)) < a) )
                        plot(samples_x0(l,2),samples_x0(l,3),'og','MarkerSize',5,'MarkerFaceColor','green');
                    else
                        plot(samples_x0(l,2),samples_x0(l,3),'xr','MarkerSize',5);
                    end
                else
                    plot(samples_x0(l,2),samples_x0(l,3),'xr','MarkerSize',5);
                end
             else
                plot(samples_x0(l,2),samples_x0(l,3),'xr','MarkerSize',5);
             end
           end 
       end
       plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','blue');
       plot(sphericalSectorCenter(2),sphericalSectorCenter(3),'d','MarkerSize',7,'MarkerFaceColor','blue');
       plot(sphericalSectorNegativeCenter(2),sphericalSectorNegativeCenter(3),'d','MarkerSize',7,'MarkerFaceColor','blue');
       grid on;
       xlabel('y (m)');
       ylabel('z (m)');
       axis equal;
 
       
       % z=0 plane
       f5 = figure(5);
       clf(f5);
       set(f5,'name','RF as a spherical sector - z=0 projection');
       hold on; 
       for l=1:size(samples_z0,1)
           if(samples_z0(l,3) >= 0)
               if (samples_z0(l,3)<=Z_MAX)
                 distance = sqrt( (samples_z0(l,1)-sphericalSectorCenter(1))^2 + (samples_z0(l,2)-sphericalSectorCenter(2))^2 + (samples_z0(l,3)-sphericalSectorCenter(3))^2);
                 if distance<=max_radius_z
                    a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + samples_z0(l,3));
                    if( (abs(samples_z0(l,1)) < a) && (abs(samples_z0(l,2)) < a) )
                        plot(samples_z0(l,1),samples_z0(l,2),'og','MarkerSize',5,'MarkerFaceColor','green');
                    else
                        plot(samples_z0(l,1),samples_z0(l,2),'xr','MarkerSize',5);
                    end
                 else
                    plot(samples_z0(l,1),samples_z0(l,2),'xr','MarkerSize',5);
                 end
               else
                 plot(samples_z0(l,1),samples_z0(l,2),'xr','MarkerSize',5);
               end
           else
             if (samples_z0(l,3)>=Z_NEGATIVE_MAX)
                distance = sqrt( (samples_z0(l,1)-sphericalSectorNegativeCenter(1))^2 + (samples_z0(l,2)-sphericalSectorNegativeCenter(2))^2 + (samples_z0(l,3)-sphericalSectorNegativeCenter(3))^2);
                if distance<=max_radius_z_neg
                    a = tan(APERTURE_RAD/2) * (CONE_HEIGHT_AT_OFFSET + abs(samples_z0(l,3)));
                    if( (abs(samples_z0(l,1)) < a) && (abs(samples_z0(l,2)) < a) )
                        plot(samples_z0(l,1),samples_z0(l,2),'og','MarkerSize',5,'MarkerFaceColor','green');
                    else
                        plot(samples_z0(l,1),samples_z0(l,2),'xr','MarkerSize',5);
                    end
                else
                    plot(samples_z0(l,1),samples_z0(l,2),'xr','MarkerSize',5);
                end
             else
                plot(samples_z0(l,1),samples_z0(l,2),'xr','MarkerSize',5);
             end
           end 
       end
       plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','blue');
       plot(sphericalSectorCenter(1),sphericalSectorCenter(2),'d','MarkerSize',7,'MarkerFaceColor','blue');
       plot(sphericalSectorNegativeCenter(1),sphericalSectorNegativeCenter(2),'d','MarkerSize',7,'MarkerFaceColor','blue');
       grid on;
       xlabel('x (m)');
       ylabel('y (m)');
       axis equal;

  end
   

%% save figures
if SAVE_FIGS
    saveas(f2,'maximumRFfigs/SphericalSector.fig');
    print -f2 -djpeg 'maximumRFfigs/SphericalSector.jpg';
    if PLOT_PROJECTIONS
        saveas(f3,'maximumRFfigs/SphericalSector_y0projection.fig');
        print -f3 -dpng 'maximumRFfigs/SphericalSector_y0projection.png';
        saveas(f4,'maximumRFfigs/SphericalSector_x0projection.fig');
        print -f4 -dpng 'maximumRFfigs/SphericalSector_x0projection.png';
        saveas(f5,'maximumRFfigs/SphericalSector_z0projection.fig');
        print -f5 -dpng 'maximumRFfigs/SphericalSector_z0projection.png';
    end
end

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



