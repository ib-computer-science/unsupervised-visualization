// unsupervised_hclust_customers.asy
// Hierarchical (agglomerative) clustering of the 9 customers in
// unsupervised_customer_data.asy, segmenting them by basket similarity.
//
// Derivation (Jaccard distance between baskets, UPGMA/average-linkage
// clustering -- computed offline, not recomputed here). Recomputed after
// Diapers was dropped from the catalog (see unsupervised_customer_data.asy)
// -- removing an item changes basket sizes/intersections, so both the tree
// shape and merge heights shifted slightly, though the final 2-segment
// split is unchanged:
//   Merge sequence (id: left + right, height = avg. Jaccard distance):
//     N0: C2 + C4   height=0.000   (identical baskets: Beer, Chips)
//     N1: C3 + C7   height=0.000   (identical baskets: Beer, Bread, Chips)
//     N2: C1 + C8   height=0.250
//     N3: C5 + N1   height=0.250
//     N4: C6 + N2   height=0.375
//     N5: N0 + N3   height=0.389
//     N6: C9 + N4   height=0.417
//     N7: N5 + N6   height=0.878   (root)
//   Leaf order (left to right, no edge crossings): C2,C4,C5,C3,C7,C9,C6,C1,C8
//   Cutting at height 0.6 (between the last internal merge at 0.417 and the
//   root at 0.878) yields exactly 2 segments: {C2,C4,C5,C3,C7} (snacks/beer
//   buyers) and {C9,C6,C1,C8} (family/staples buyers).

import unsupervised_theme;
import unsupervised_dendrogram;

real yScale = 8;  // plot-units per unit of Jaccard distance

void drawHclustDiagram(picture pic, Theme theme) {
    // --- Leaves, in clustering order, 1 plot-unit apart
    pair posC2 = (0,0);
    pair posC4 = (1,0);
    pair posC5 = (2,0);
    pair posC3 = (3,0);
    pair posC7 = (4,0);
    pair posC9 = (5,0);
    pair posC6 = (6,0);
    pair posC1 = (7,0);
    pair posC8 = (8,0);

    string[] leafLabel = {"$C_2$","$C_4$","$C_5$","$C_3$","$C_7$",
                           "$C_9$","$C_6$","$C_1$","$C_8$"};
    pair[] leafPos = {posC2,posC4,posC5,posC3,posC7,posC9,posC6,posC1,posC8};
    for (int i = 0; i < leafPos.length; ++i)
        drawDendroLeaf(pic, leafPos[i], leafLabel[i], theme);

    // --- Merges, in the order they occur (increasing height)
    pair posN0 = drawDendroMerge(pic, posC2, posC4, 0.000*yScale, theme);
    pair posN1 = drawDendroMerge(pic, posC3, posC7, 0.000*yScale, theme);
    pair posN2 = drawDendroMerge(pic, posC1, posC8, 0.250*yScale, theme);
    pair posN3 = drawDendroMerge(pic, posC5, posN1, 0.250*yScale, theme);
    pair posN4 = drawDendroMerge(pic, posC6, posN2, 0.375*yScale, theme);
    pair posN5 = drawDendroMerge(pic, posN0, posN3, 0.389*yScale, theme);
    pair posN6 = drawDendroMerge(pic, posC9, posN4, 0.417*yScale, theme);
    drawDendroMerge(pic, posN5, posN6, 0.878*yScale, theme);

    // --- Distance axis
    drawDendroHeightAxis(pic, theme, -1.5, 0.9, yScale, 0.2, "avg. Jaccard distance");

    // --- Cut line: slices the tree into 2 customer segments
    drawDendroCutLine(pic, theme, 0.6*yScale, -0.6, 8.6, "cut $\to$ 2 segments");

    // --- Segment labels, just below the cut line on each branch
    label(pic, "snacks/beer buyers", (posN5.x, 0.6*yScale - 0.4), theme.text);
    label(pic, "family/staples buyers", (posN6.x, 0.6*yScale - 0.4), theme.text);
}

void renderHclustDiagram(pen background, pen foreground) {
    Theme theme = newTheme(background, foreground);
    picture pic;
    drawHclustDiagram(pic, theme);
    renderTheme(pic, theme);
}

renderHclustDiagram(black, white);
