function im = stitch_images_4(sImage, cImage, H)

sh = size(sImage,1);
sw = size(sImage,2);
ch = size(cImage,1);
cw = size(cImage,2);


c_vtx = [1,1,1;cw,1,1;1,ch,1;cw,ch,1]';

c_vtx_trans = H * c_vtx;

for i = 1:size(c_vtx_trans,2)
    c_vtx_trans(:,i) = c_vtx_trans(:,i) / c_vtx_trans(end,i);
end

c_vtx_trans = round(c_vtx_trans);

w_max = sw;
w_min = 0;
h_max = sh;
h_min = 0;

for i = 1:4
    if c_vtx_trans(1,i) > w_max
        w_max = c_vtx_trans(1,i);
    elseif c_vtx_trans(1,i) < w_min
        w_min = c_vtx_trans(1,i);
    end

    if c_vtx_trans(2,i) > h_max
        h_max = c_vtx_trans(2,i);
    elseif c_vtx_trans(2,i) < h_min
        h_min = c_vtx_trans(2,i);
    end
end


w_out = w_max - w_min + 1;
h_out = h_max - h_min + 1;

im = zeros(h_out,w_out,3);
ims = zeros(h_out,w_out,3);
imc = zeros(h_out,w_out,3);

offsetY = -h_min;
offsetX = -w_min;

T = [1,0,offsetX;0,1,offsetY;0,0,1];

for i = 1:sh
	for j = 1:sw
		ims(i+offsetY,j+offsetX,:) = sImage(i,j,:);
	end
end

invH = inv(H);
invT = inv(T);
% invM = invH * invT;
for y = 1: h_out
	for x = 1:w_out
		pt = invH * invT * [x;y;1];
        pt = pt / pt(3);
		rgb = getColor(cImage,pt(1),pt(2));
        if rgb ~= 0 
            imc(y,x,:) = rgb;
        end
	end
end

overlap = ims & imc;

errpatch = sum((ims .* overlap - imc .* overlap).^2, 3);

temp = ones(size(ims));
temp = temp .* 255^2;
temp = temp .* ~overlap;
temp2d = sum(temp,3);

errpatch = errpatch + temp2d;


mask = transpose(cut(errpatch'));

mask = mask .* overlap(:,:,1);

ims_overlap = ims .* overlap;
imc_overlap = imc .* overlap;

mask3d = zeros(size(mask,1),size(mask,2),3);
mask3d(:,:,1) = mask;
mask3d(:,:,2) = mask;
mask3d(:,:,3) = mask;

im = (ims - ims_overlap) + (imc - imc_overlap) + ims_overlap .* ~mask3d + imc_overlap .* mask3d;


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
