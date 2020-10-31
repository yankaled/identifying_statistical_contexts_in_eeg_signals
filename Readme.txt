This folder contains the source code for the undergrad research "Identifying statistical contexts in EEG signals".
The codes here heavily rely on the codes implemented by Noslen Hernández and Aline Duarte of NeuroMat, which can be found at https://github.com/neuromat/EEGretrieving

##  SOURCE CODE

All QUATERNARY files have as base the code in QUATERNARY_CONDITION.m, implemented by Aline Duarte and Noslen Hernández. It contains the source code for the statistical analysis done in the Quaternary condition, respectively. By running the QUATERNARY_CONDITION.m script you will obtain:

-- a cell array called tree_array_qua of dimension 19x18 containing on each column the 19 context trees estimated for all participants for a given electrode.
    
-- a cell array called mode_context_tree_qua containing the mode context trees.

The rest of the .m files are the functions implementing the statistical procedures. There are two main functions, which are directly invoked in the QUATERNARY_CONDITION.m and TERNARY_CONDITION.m files:

1) estimate_functionalSeqRoCTM.m: this function estimates a context tree from the sequence of stimuli X and the corresponding sequence of EEG chunks Y.  

2) mode_tree.m: compute the mode context tree of a set of context trees.

Detailed information on the inputs, outputs, usage, etc can be found as comments in the scripts. 

The rest of .m files are auxiliary functions used in the implementation of estimate_functionalSeqRoCTM.m: 

- brownianbridge.m: generate a Brownian Bridge.
- completetree.m and is_leaf.m: compute a complete tree.
- stat_ks_projective.m: compute the statistic used to decide if a branch is pruned or not during the punning procedure involved in the model selection algorithm. 

