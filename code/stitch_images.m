function im = stitch_images(sImage, cImage, H)

sh = size(sImage,1);
sw = size(sImage,2);
ch = size(cImage,1);
cw = size(cImage,2);

% [cx,cy] = meshgrid(1:ch,1:cw);
% 
% cGrid = zeros(ch,cw,2);
% cGrid(1,:,:) = cx;
% cGrid(2,:,:) = cy;
% 
% cImage_trans = zeros(ch,cw,2);
% 
% for i = 1:cx
%     for j = 1:cy
%         cImage_trans(:,i,j) = T * cGrid(:,i,j);
%     end
% end


c_vtx = cell(4,1);
c_vtx{1} = [1;1;1]; % [y;x;1]
c_vtx{2} = [cw;1;1];
c_vtx{3} = [1;ch;1];
c_vtx{4} = [cw;ch;1];


c_vtx_trans = cell(4,1);
c_vtx_trans{1} = round(H * c_vtx{1});
c_vtx_trans{2} = round(H * c_vtx{2});
c_vtx_trans{3} = round(H * c_vtx{3});
c_vtx_trans{4} = round(H * c_vtx{4});

w_max = sw;
w_min = 0;
h_max = sh;
h_min = 0;

for i = 1:4
	for j = 1:4
		if c_vtx_trans{i}(1) > w_max
			w_max = c_vtx_trans{i}(1);
		elseif c_vtx_trans{i}(1) < w_min
			w_min = c_vtx_trans{i}(1);
		end
		
		if c_vtx_trans{i}(2) > h_max
			h_max = c_vtx_trans{i}(2);
		elseif c_vtx_trans{i}(2) < h_min
			h_min = c_vtx_trans{i}(2);
		end
		
	end
end


w_out = w_max - w_min + 1;
h_out = h_max - h_min + 1;

im = zeros(h_out,w_out,3);

offsetY = -h_min;
offsetX = -w_min;

T = [1,0,offsetX;0,1,offsetY;0,0,1];

for i = 1:sh
	for j = 1:sw
		im(i+offsetY,j+offsetX,:) = sImage(i,j,:);
	end
end

invH = inv(H);
invT = inv(T);
% invM = invH * invT;
for y = 1: h_out
	for x = 1:w_out
		% compute pixel value from cImage
		pt = invH * invT * [x;y;1];
		rgb = getColor(cImage,pt(1),pt(2));
		if im(y,x,:) == 0 
			im(y,x,:) = rgb;
        else
            im(y,x,1) = im(y,x,1) + rgb(1);
            im(y,x,2) = im(y,x,2) + rgb(2);
            im(y,x,3) = im(y,x,3) + rgb(3);
			im(y,x,:) = im(y,x,:) * 0.5;
		end
	end
end


end


function rgb = getColor(im,x,y)
if x < 1 || x > size(im,2) ...
        || y < 1 || y > size(im,1)
    rgb = [0,0,0];
    return
end
y_floor = floor(y);
y_ceil = ceil(y);
x_floor = floor(x);
x_ceil = ceil(x);
rgb = im(y_floor, x_floor, :) * (x_ceil - x) * (y_ceil - y) ...
    + im(y_ceil, x_floor, :) * (x_ceil - x) * (y - y_floor) ...
    + im(y_floor, x_ceil, :) * (x - x_floor) * (y_ceil - y) ...
    + im(y_ceil, x_ceil, :) * (x - x_floor) * (y - y_floor);
end
