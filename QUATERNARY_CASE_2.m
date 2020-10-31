% Statistical Analysis for the Quaternary Tree

% number of the electrodes used in the statistical analysis
target_electrodes = [9, 11, 22, 24, 33, 36, 45, 52, 58, 62, 70, 83, 92, 96, 104, 108, 122, 124];

% alphabet
A = [0,1,2];

% values of the parameters  
height_complete_tree = 3;	% height of the complete tree
n_BM = 5000;				% number of Brownian motions
alpha = 0.05;				% significance of the ks-test
beta = 0.05;				% Bernoulli parameter

% variable to store the estimated context tree for each participant and each electrode
tree_array_qua_second_first = cell(19,18); %second interval
tree_array_qua_second_second = cell(19,18); %third interval

% for each participant and each electrode, estimate a context tree from the EEG data
participant_counter = 1;

for s = [1:3 5:20] 		% for each participant, discarding participant 4

    % load the data of the subject
    name = ['V' num2str(s,'%02d') '.mat'];
    load(['preprocessed_data/' name]);
    
	% load the sequence of stimuli
    X = data.X_qua;
    
   % verify if electrode information match
   electrodes = cellfun(@(x) str2double(x(2:end)), data.Y_qua(1,:), 'UniformOutput', true); 
   
   if sum(electrodes == target_electrodes) == 18
       for electrode_counter = 1 : 18
           disp(['Processing Participant ' name(1:end-4) ', electrode ' num2str(electrode_counter) '...']);
           % load the EEG data of the interval [159.29, 306.63] in ms (rows 40 - 77)
		   Y_second_first = data.Y_qua{2,electrode_counter}(40:77, 1:793);
           %loop for modeling the first interval only
           for i = 1:793
               baseline_second_first = mean(Y_second_first(1:8,i));
               for j = 1:38
                   Y_second_first(j,i) = Y_second_first(j,i) - baseline_second_first;
               end
           end
           
           % load the EEG data for the last 290.71 ms (rows 40 - 113) 
		   Y_second_second = data.Y_qua{2,electrode_counter}(77:113, 1:793);
           %loop for modeling the second interval only
           for i = 1:793
               baseline_second_second = mean(Y_second_second(1:8,i));
               for j = 1:37
                   Y_second_second(j,i) = Y_second_second(j,i) - baseline_second_second;
               end
           end
           
		   % fix the seed to use the same Brownian motions for all participants and electrodes
           rng(1)
		   % estimate the context tree	
           tree_second_first = estimate_functionalSeqRoCTM(X, Y_second_first, A, height_complete_tree, n_BM, alpha, beta);
           tree_second_second = estimate_functionalSeqRoCTM(X, Y_second_second, A, height_complete_tree, n_BM, alpha, beta);
           % store the context trees
           tree_array_qua_second_first{participant_counter, electrode_counter} = tree_second_first; 
		   tree_array_qua_second_second{participant_counter, electrode_counter} = tree_second_second; 
       end
   else
       disp('EEG information about electrodes does not match the selected electrodes.')
   end
   participant_counter = participant_counter + 1;
end

save('quaternary_trees_second_first', 'tree_array_qua_second_first');
save('quaternary_trees_second_second', 'tree_array_qua_second_second');

% compute the mode context tree on each electrode
mode_context_tree_qua_second_first = cell(18,1);    % mode context tree for each electrode
mode_context_tree_qua_second_second = cell(18,1);

for e = 1 : 18
    trees_second_first = tree_array_qua_second_first(:,e);
	mode_context_tree_qua_second_first{e} = mode_tree(trees_second_first, A);
    trees_second_second = tree_array_qua_second_second(:,e);
	mode_context_tree_qua_second_second{e} = mode_tree(trees_second_second, A);
end
save('mode_context_tree_qua_second_first', 'mode_context_tree_qua_second_first');
save('mode_context_tree_qua_second_second', 'mode_context_tree_qua_second_second');