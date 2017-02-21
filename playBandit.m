% 
% Created on Jan 10, 2015
% @author: Johannes Feldmaier <johannes.feldmaier@tum.de>
%     Copyright (C) 2015  Johannes Feldmaier
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function [ reward, new_state ] = playBandit( action, numArms, mu, sigma )
% Produces the reward for a N-armed bandit process 
% with the means mu and standard deviation sigma 
% for each arm
% give sigma as: sigma = [1,4]
% give mu as: mu = [10,8]

probs = sigma'.*randn(numArms,1) + mu';

reward = probs(action);

new_state = action; % <- assuming a fully deterministic state transition

% Plot continous distribution
%histogram(probs,'BinWidth',1,'FaceColor','blue','Normalization','pdf')
%f2 = (   1/(sigma*sqrt(2*pi))   )  *  exp(-0.5*((x-mu)/sigma).^2  );

end

