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

figure

subplot(211)

x = 0:.01:1;

plot(x,ones(1,length(x)))

hold on

% y = normpdf(x,0.5,0.15);

mu = 0.5;
% sigma = 0.12;

sigma = 1/(5*sqrt(2*pi));

y = 5 * exp(-(x-mu).^2/(2*sigma^2));

plot(x,y)

mu = 1;

y = 5 * exp(-(x-mu).^2/(2*sigma^2));

plot(x,y)

hold off

subplot(212)

x = 1:300;

y = 1 - 1 ./ (1 + ( x / (0.5*300) ).^(1+exp(1)));

plot(x,y)