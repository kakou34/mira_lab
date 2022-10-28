function mi = mutual_information(img_fix, img_reg)
% This function calculates the mutual information between two 2D images 
%
% mi = mutual_information(img_fix, img_reg)
%
% inputs,
%   img_fixed: The fixed image 
%   img_ref: The registered image (registration result)
%
% output,
%   mi: The mutual information between img_fix and img_mov
%
% Function based on one by D.Kroon University of Twente (February 2009)
    hist_2d = hist3([img_fix(:), img_reg(:)], 'nbins', [10, 10]);
    pxy = hist_2d / sum(sum(hist_2d)); % normalized 2d histogram
    px = sum(pxy, 1); % the sum over x (1x10)
    py = sum(pxy, 2); % the sum over y (10x1)
    px_py = py * px; % multiplication of px py  (10x10)
    nzr = pxy> 0; % take only non zero elements 
    mi = sum(pxy(nzr) .* log2(pxy(nzr)./px_py(nzr))); % compute mutual information
end

