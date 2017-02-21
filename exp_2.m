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

function exp_2()

numExperiments = 10;
trials = 300;

clear save_actions save_reward save_experience arm_selections

save_actions = zeros(trials,numExperiments);
save_reward = zeros(trials,numExperiments);
save_experience = zeros(trials,numExperiments);

for i = 1:numExperiments
    
    [hist, Q] = perform_experiment(trials);
    
    disp(['Exp: ' num2str(i) ' - Q: ' num2str(Q)]);
    
    save_actions(:,i) = hist(1,:);
    save_reward(:,i) = hist(3,:);
    save_experience(:,i) = hist(4,:);
    
    
   
end

plot_action_stat(save_actions, save_reward, save_experience)

end

function [hist, Q] = perform_experiment(trials)

% Initialization
numActions = 3;
numStates = 1;

s = randi(numStates); %state
Q = zeros(numStates,numActions);
hist = zeros(4,trials);

% Q-learning
epsilon = 0.05; %greedy action
alpha = 0.8; %learning rate
gamma = 0.4; %discount factor

% Experiment Settings
mu = [1 1 1]; % "Bottles"
sigma = [1 1 1]; % variations of taste

experience = 0;

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
    experience = experience + (1-experience) * 0.01 * t*0.015;
    
    nu2 = 0.5;
    nu3 = 1;
    sig = 1 / (5*sqrt(2*pi));
    
    switch a
        case 1
            reward_bonus = 0;
        case 2
            reward_bonus = (1/(sqrt(2*pi) * sig)) * exp((experience - nu2)^2 / (2 * sig^2));
        case 3
            reward_bonus = (1/(sqrt(2*pi) * sig)) * exp((experience - nu3)^2 / (2 * sig^2));
    end
    
%     reward_bonus = 0;
    
    r = r_ext + reward_bonus;
    
    % Q learning update
    Q(s,a) = Q(s,a) + alpha * (r + gamma * max(Q(s,:)) - Q(s,a));
    
    
    % Advance to next round and update:
    hist(:,t) = [a,r_ext,r,experience];
    
    
end


end




function plot_action_stat(save_actions, save_reward, save_experience)

    trials = size(save_actions,1);
    numExperiments = size(save_actions,2);

    arm_selections(:,1) = sum(save_actions == 1,2);
    arm_selections(:,2) = sum(save_actions == 2,2);
    arm_selections(:,3) = sum(save_actions == 3,2);
    
    plot_size = mean([max(max(arm_selections(:,1))), max(max(arm_selections(:,2))),max(max(arm_selections(:,3)))]);
    scatter_size = 500;
    
    x_intermediate = find(mean(save_experience,2) >= 0.5,1);
    x_expert = find(mean(save_experience,2) >= 0.95,1);
    
    %subplot(211)
    positionVector1 = [0.05, 0.40, 0.92, 0.54];
    positionVector2 = [0.05, 0.05, 0.92, 0.27];
    subplot('Position',positionVector1)
    %h1 = plot(1:trials,smooth(mean(save_actions,2)),'Color','black','LineWidth',1.5);
    hold
    a1 = 0+any((save_actions==1)');
    a1size = a1;
    a1(a1 == 0) = NaN;
    %a1size = scatter_size.*((arm_selections(:,1)./max(max(arm_selections(:,1)))+0.01)).^2;
    a1size = scatter_size.*((arm_selections(:,1)./plot_size)+0.01).^2;
    h1 = scatter(1:trials,3.*a1,a1size','Marker','o','MarkerFaceColor','flat');
    
    a2 = 0+any((save_actions==2)');
    a2size = a2;
    a2(a2 == 0) = NaN;
    %a2size = scatter_size.*((arm_selections(:,2)./max(max(arm_selections(:,2)))+0.01)).^2;
    a2size = scatter_size.*((arm_selections(:,2)./plot_size)+0.01).^2;
    h2 = scatter(1:trials,2.*a2,a2size','Marker','o','MarkerFaceColor','flat');
    
    a3 = 0+any((save_actions==3)');
    a3size = a3;
    a3(a1 == 3) = NaN;
    %a3size = scatter_size.*((arm_selections(:,3)./max(max(arm_selections(:,3)))+0.01)).^2;
    a3size = scatter_size.*((arm_selections(:,3)./plot_size)+0.01).^2;
    h3 = scatter(1:trials,1.*a3,a3size','Marker','o','MarkerFaceColor','flat');
    
    % h1 = scatter(1:trials,save_actions(:,1),[],save_actions(:,1).*10,'Marker','.');
    % hold
    % for i = 2:numExperiments
    %     scatter(1:trials,save_actions(:,i),[],save_actions(:,i).*10,'Marker','.');
    % end
    ylim([0 4])
    line([0 trials],[1 1],'LineStyle','--','Color','black')
    line([0 trials],[2 2],'LineStyle','--','Color','black')
    line([0 trials],[3 3],'LineStyle','--','Color','black')
    line([x_intermediate x_intermediate],[0 4],'LineStyle','--','Color','black')
    line([x_expert x_expert],[0 4],'LineStyle','--','Color','black')
    ax1 = gca;
    ax1.XTick = [0, 50, 100, 150, 200, 250, 300];
    ax1.YTick = [1, 2, 3];
    set(ax1,'YTickLabel',['3';'2';'1'])
    ylabel('Action')
    %xlabel('Trial')
    hold
%     title([exp_titles{k}, 10, 'a_1: ', num2str((sum(arm_selections(:,1))./(numExperiments * trials))*100,2), '% - a_2: ', ...
%         num2str((sum(arm_selections(:,2))./(numExperiments * trials))*100,2), '% - a_3: ', ...
%         num2str((sum(arm_selections(:,3))./(numExperiments * trials))*100,2), '%'])
    
    
    %subplot(212)
    
    subplot('Position',positionVector2)
    h2 = plot(1:trials,mean(save_experience,2),'LineWidth',1.5,'Color',[0.4660    0.6740    0.1880]);
    ax2 = gca;
    hold
    line([x_intermediate x_intermediate],[0 1],'LineStyle','--','Color','black')
    line([x_expert x_expert],[0 1],'LineStyle','--','Color','black')
    text(5,0.8,'Beginner')
    text(x_intermediate+1,0.8,'Intermediate')
    text(x_expert+1,0.8,'Expert')
    %legend('reward','experience','Location','northwest')
    box off
    ax2.XTick = [0, 50, 100, 150, 200,250,300];
    ax2.YTick = [0, 0.5, 1];
    ylabel({'Level of Experience';'S_A'})
    xlabel('Trial')
    hold
    
end