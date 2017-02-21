# Name of the Project: 

Reinforcement Learning with Preferences

Learn specific preferences according to an externally controlled affective state in context of a bandit simulation.

# Institution:

Chair of data processing @ Technical University of Munich

# Contributors:

Johannes Feldmaier <johannes.feldmaier@tum.de>, 

# Description:

This is the extended RL framework which can learn different preferences of actions according to an affective State. The state is used to shape the reward in a multi-objective scenario. The formulation of the affective state fulfills the Markov property. 

The results were presented at the RLDM 2015 conference in Edmonoten, Alberta, Canada (http://rldm.org/). The title of the paper was "Reinforcement Learning with Preferences".

Written in Matlab 2015b.
 
# Getting Started:

1. After cloning the repository run `exp_2.m` in parent directory. 

2. The results should be generated and saved in your working directory. 

3. You can use "perform_experiment(trials)" to run a signle iteration of an experiment. The initial parameters of the experiment can be adjusted in the 'exp_2.m' file. 