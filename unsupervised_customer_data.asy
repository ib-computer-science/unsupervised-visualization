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

string[] items = {"Bread", "Milk", "Eggs", "Diapers", "Beer", "Chips"};
string[] customerIds = {"C1","C2","C3","C4","C5","C6","C7","C8","C9"};

// Basket contents (ground truth for every derived number in both diagrams):
//   C1: Bread, Milk, Eggs, Diapers      C6: Beer, Chips, Bread
//   C2: Bread, Milk, Diapers            C7: Beer, Chips
//   C3: Milk, Eggs, Diapers             C8: Chips, Beer, Bread
//   C4: Bread, Milk, Eggs               C9: Bread, Milk, Beer, Chips
//   C5: Beer, Chips
