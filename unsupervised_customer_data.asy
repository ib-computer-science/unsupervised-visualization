// unsupervised_customer_data.asy
// Shared simulated dataset for the unsupervised-learning diagrams: 9
// customers' purchase "baskets" over a small product catalog, in a
// customer-segmentation scenario.
//
// unsupervised_hclust_customers.asy segments these customers by basket
// similarity (Jaccard distance + UPGMA linkage); unsupervised_assocrules_
// customers.asy mines item co-occurrence (support/confidence/lift) across
// the same baskets. Both diagrams hardcode their derived numbers locally,
// each with a comment citing this basket table as the source, rather than
// recomputing clustering/frequent-itemset logic in Asymptote.
//
// Which customer ID holds which basket was randomized (Python random,
// seed=42) from an original 1:1 labeling -- the 9 basket contents
// themselves are unchanged, only the ID each is filed under. Itemset
// statistics (support/confidence/lift) depend only on the multiset of
// baskets, so they're unaffected by this relabeling; the dendrogram's tree
// shape and merge heights are likewise unaffected, only its leaf labels.
//
// Diapers was dropped from the catalog: under this randomized assignment
// it was purchased by exactly the same customers as Applesauce (C6, C8,
// C9), making the two columns identical and Diapers redundant as a
// segmentation signal.

string[] items = {"Applesauce", "Bread", "Milk", "Eggs", "Beer", "Chips"};
string[] customerIds = {"C1","C2","C3","C4","C5","C6","C7","C8","C9"};

// Basket contents (ground truth for every derived number in both diagrams):
//   C1: Bread, Eggs, Milk                    C6: Applesauce, Eggs, Milk
//   C2: Beer, Chips                          C7: Beer, Bread, Chips
//   C3: Beer, Bread, Chips                   C8: Applesauce, Bread,
//   C4: Beer, Chips                              Eggs, Milk
//   C5: Beer, Bread, Chips, Milk             C9: Applesauce, Bread, Milk
