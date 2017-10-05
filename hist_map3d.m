%% About 
% Function to display the receptive field of a skin taxel
% pos: position of skin taxel
% range: vector of sample of distance to taxel
% parzenFunc: parzen estimation value of pps activation
% varargin(1): resolution of visualization
% varargin(2): transparent of visualization

% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com

%%
function [ h ] = hist_map3d( pos, range, parzenFunc,varargin )
%HIST_MAP3D Function to display the receptive field of a skin taxel
%   Detailed explanation goes here
%   pos: position of skin taxel
%   range: vector of sample of distance to taxel
%   parzenFunc: parzen estimation value of pps activation
%   varargin(1): resolution of visualization
%   varargin(2): transparent of visualization

res = 100;
transparent = 1;

if (~isempty(varargin))
    if (length(varargin)>=1)
        res = varargin{1};
    elseif(length(varargin)>=2)
            res = varargin{1};
            transparent = varargin{2};
    end
end

angle = 80/180*pi;  % cone angle
L = range(end)-range(1);

G = pos;

d = L/length(parzenFunc);
a = repmat(parzenFunc',[1,length(parzenFunc)]);
size(a);
i = 1;

for radius = range(1):10*d:range(end)
    %  radius is not the radius at the base, but radius of the circles
    %  (surfaces) drawn from the apex - in the z-plane (taxel normal)
    %     iValue = i
    %     rad = radius
    theta = linspace(0,2*pi,res);

    phi = linspace((pi-angle)/2,pi/2,res);
    [theta,phi] = meshgrid(theta,phi);
    [xs,ys,zs] = sph2cart(theta,phi,radius);

    b = parzenFunc(10*i)*ones(length(theta));
    h(i) = mesh(xs+G(1),ys+G(2),zs+G(3),b);
    set(h(i),'FaceAlpha',transparent);
    i = i+1;
    if i>(length(parzenFunc)/10)
        break;
    end
end
colorbar

end

