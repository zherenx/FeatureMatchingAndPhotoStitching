function im = stitch_images_2(sImage, cImage, H)

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
