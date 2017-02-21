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

function hist = preferenceRL_longrun( trials )

numActions = 3;
numStates = 1;

exp_arr = [0,0.5,1];

% Experiment Settings
mu = [1 1 1]; % "Bottles"
sigma = [1 1 1]; % variations of taste

% Experience Level (internal state)
experience = 0; %beginner
% experience = 0.5; %intermediate
%  experience = 1; %expert

% Experience model
mu_beg = [1 1 1]; % beginner
sigma_beg = [1 1 1]; 
mu_int = [1 10 1]; % intermediate
sigma_int = [1 1 1]; 
mu_exp = [1 1 15]; % expert
sigma_exp = [1 1 1]; 

% Initialization
a = randi(numActions); % action
s = randi(numStates); %state
Q = zeros(numStates,numActions);
hist = zeros(4,trials);

% Q-learning
epsilon = 0.05; %greedy action
alpha = 0.8; %learning rate
gamma = 0.4; %discount factor

for t = 1:trials 
    
    if( rand<=epsilon )
        % perform exploratory step
        a = randi(numActions);
    else
        % pick the best action to play
        if all(Q(s,:) == Q(s,1))
            a  = randi(numActions); % random action
        else
            [~, a] = max(Q(s,:));
        end
    end
    
    % Play bandit
    [ r_ext, ~ ] = playBandit( a, numActions, mu, sigma );
    
    % Experience evaluation
    reward_bonus = 0;
    if experience >= 0 % beginner
        % no reward bonus 
        reward_bonus = playBandit( a, numActions, mu_beg, sigma_beg ); 
    end
    if experience >= 0.5 % intermediate
        reward_bonus = playBandit( a, numActions, mu_int, sigma_int ); 
    end
    if experience >= 0.95 % expert
        reward_bonus = reward_bonus + playBandit( a, numActions, mu_exp, sigma_exp );
    end
    
    r = r_ext + reward_bonus;
        
    % Q learning update
    Q(s,a) = Q(s,a) + alpha * (r + gamma * max(Q(s,:)) - Q(s,a));
    
           
    % Advance to next round and update:
    hist(:,t) = [a,r_ext,r,experience];
    % experience is updated at each time step
%     if t == 50
%         experience = 0.5;
%     elseif t == 100
%         experience = 1;
%     end
     experience = experience + (1-experience) * 0.01 * t*0.015;
%      if t < 200
%          experience = 1 - exp(-t/25);
%      else
%          experience = 1;
%      end
     %experience = (1/trials) * t;
    
    
end


% figure
% plot(1:trials,hist(3,:),1:trials,hist(4,:).*100,1:trials,hist(1,:).*100)
% legend('reward','experience','action')

end


% helping hands


%     X = -5:0.01:5;
%     Y1 = (40.*exp(-((X)./0.24).^2))-20;
%     Y2 = (80.*exp(-((X-0.5)./0.14).^2))-10;
%     Y3 = (140.*exp(-((X-1)./0.27).^2))-40;
%     plot(X,Y1,X,Y2,X,Y3)
%     xlim([-1 2])
%     
%     X = -5:0.01:5;
%     Y1 = (2.*sigmf(X,[20,0.2]))-1;
%     Y2 = (2.*sigmf(X,[20,0.4]))-1;
%     Y3 = (2.*sigmf(X,[20,0.7]))-1;
%     plot(X,Y1,X,Y2,X,Y3)
%     hold on
%     line([-1 2],[0 0],'Color','black')
%     line([0 0],[-3 3],'Color','black')
%     line([1 1],[-3 3],'Color','black')
%     xlim([-1 2])
%     hold off
%     
    
    