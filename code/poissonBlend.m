function im_blend = poissonBlend(im_s, mask_s, im_background)
    im_blend = zeros(size(im_background));

    [imh, imw, nb] = size(im_background);
    im2var = zeros(imh, imw);
    im2var(1:imh*imw) = 1:imh*imw;
    
    for channel = 1:nb
%         e = 0;
%         b = zeros(imh*imw, 1);
        
        [Ay, Ax, Aval, b] = poissonConstructData(im_s(:, :, channel), mask_s(:, :, channel), im_background(:, :, channel), im2var);
        
%         Ay = [];
%         Ax = [];
%         Aval = [];
%         
%         for y = 1:imh
%             for x = 1:imw
%                 e = e + 1;
% 
%                 % If pixel is not under the mask, copy the target pixel
%                 % directly
%                 if ~mask_s(y, x)
%                     Ay = [Ay; e]; Ax = [Ax; im2var(y,x)]; Aval = [Aval; 1];  % A(e, im2var(y,x)) = 1;
%                     b(e) = im_background(y, x, channel);
% 
%                 % Pixel not under mask
%                 elseif mask_s(y, x)
%                     if x == imw && y == imh
%                         neighbours = { {y-1,x} {y,x-1} };
%                     elseif x == 1 && y == 1
%                         neighbours = { {y+1,x} {y,x+1} };
%                     elseif x == imw && y == 1
%                         neighbours = { {y+1,x} {y,x-1} };
%                     elseif x == 1 && y == imh
%                         neighbours = { {y-1,x} {y,x+1} };
%                     elseif x == 1
%                         neighbours = { {y+1,x} {y-1,x} {y,x+1} };
%                     elseif y == 1
%                         neighbours = { {y+1,x} {y,x+1} {y,x-1} };
%                     elseif x == imw
%                         neighbours = { {y+1,x} {y-1,x} {y,x-1} };
%                     elseif y == imh
%                         neighbours = { {y-1,x} {y,x+1} {y,x-1} };
%                     else
%                         neighbours = { {y+1,x} {y-1,x} {y,x+1} {y,x-1} };
%                     end
% 
% 
%                     for i = 1:numel(neighbours)
%                         n = neighbours{i};
%                         ny = n{1}; nx = n{2};
%                         
%                         % First sum of the blending constraints
%                         if mask_s(ny, nx)
%                             Ay = [Ay; e]; Ax = [Ax; im2var(y, x)];   Aval = [Aval; 1];  % A(e, im2var(y, x)) = A(e, im2var(y, x)) + 1;
%                             Ay = [Ay; e]; Ax = [Ax; im2var(ny, nx)]; Aval = [Aval; -1]; % A(e, im2var(ny, nx)) = A(e, im2var(ny, nx)) - 1;
%                             
%                             b(e) = b(e) + (im_s(y, x, channel) - im_s(ny, nx, channel));
% 
%                         % Second sum of the blending constraints
%                         else
%                             Ay = [Ay; e]; Ax = [Ax; im2var(y, x)]; Aval = [Aval; 1];    % A(e, im2var(y, x)) = A(e, im2var(y, x)) + 1;
%                             b(e) = b(e) + (im_s(y, x, channel) - im_s(ny, nx, channel)) + im_background(ny, nx, channel);
%                         end
%                     end
% 
%                 end
% 
%             end
%         end
        
        A = sparse(Ay, Ax, Aval, imh*imw, imh*imw);

        v = A \ b;
        im_blend(:, :, channel) = reshape(v, [imh imw]);
    end
end