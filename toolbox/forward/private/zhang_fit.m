function delta = zhang_fit(berg,R,f)
% ZHANG_FIT: Compute 'Berg' parameters for EEG multilayer sphere.
%
% USAGE:  delta = zhang_fit(berg,R,f)
%
% DESCRIPTION: 
%       MINIMIZATION FUNCTION FOR COMPUTING BERG PARAMETERS FOR EEG MULTILAYER 
%       SPHERICAL FORWARD MODEL
%
%       This function serves as a minimization function for determining the Berg 
%       Eccentricity and Magnitude parameters associated with a series approximation
%       of a Single Dipole in a Multilayer Sphere -by- multiple dipoles in a single shell. 
%       (Zhang: Eq 5i"). This function is intended to be called by the Matlab "fmins" 
%       function. This version has not been optimized for speed.
%
%       (Ref: Z. Zhang "A fast method to compute surface potentials generated by dipoles 
%       within multilayer anisotropic spheres" (Phys. Med. Biol. 40, pp335-349,1995)   
% 
% INPUT:
%    - berg : Contains                                              (2*J-1) x 1
%    - R    : Concentric Sphere Radii(in meters) from INNERMOST to OUTERMOST           [NL x 1]
%    - f    : Weighting terms corresponding to sphere/conductivity profile of interest [nmax x 1]
%             where: NL = # of sphere layers; nmax = # of series terms; J = # of Berg Dipoles
%
% OUTPUT:
%    - delta: Minimization function output. Best fit of 
%             Berg Eccentricity and Magnitude Paramters occurs when
%             this value is minimized

% @=============================================================================
% This function is part of the Brainstorm software:
% http://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2016 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: John J. Ermer, 1999
% ----------------------------- Script History ---------------------------------
% JJE  5-May-1999 Creation
% JCM 08-Sep-2003 Comments
% ------------------------------------------------------------------------------

NL = length(R);           % Number of Sphere Layers
nmax = length(f);         % Number of Legendre Series Terms
J = (length(berg)+1)/2;   % Infer Number of Berg Dipoles from Passed data
mu_berg = berg(1:J);      % Berg Eccentricity Factors 1->J
lam_berg = [0.0 berg(J+1:2*J-1)]; % Berg Magnitude Factors 2->J
%
delta = 0.0;  % Compute Factor to be minimized
%
for n = 2:nmax
   term0 = 0;
   for j=2:J
      term0 = term0 + lam_berg(j)*(mu_berg(j)^(n-1) - mu_berg(1)^(n-1));
   end
   term1 = ( (R(1)/R(NL))^(n-1) )* ...
     ( f(n)-f(1)*mu_berg(1)^(n-1) - term0);
   delta = delta + term1*term1;
end




