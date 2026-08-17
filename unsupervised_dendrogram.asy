// unsupervised_dendrogram.asy
// Drawing primitives for agglomerative-clustering dendrograms: leaves,
// elbow-shaped merge connectors positioned at real-valued merge heights, a
// vertical distance axis, and a horizontal cut line marking where the tree
// is sliced into segments. Every function takes a Theme (see
// unsupervised_theme.asy) so the same code renders identically in light and
// dark variants.
//
// Asymptote's built-in tree.asy / binarytree.asy / drawtree.asy packages
// were considered and ruled out: they lay out nodes at uniform per-level
// spacing with straight parent-child connectors, not at real-valued merge
// heights with the elbow/bracket connectors a dendrogram needs -- so this
// file implements that layout directly instead.
//
// Diagram scripts precompute leaf and merge-node coordinates themselves
// (from whatever linkage/distance computation produced the tree) and pass
// plain pairs to these functions, rather than this file reimplementing
// clustering.

import unsupervised_theme;

real dendroTickLen = 0.12;

// A leaf at the bottom of the tree (height 0): a short tick down from the
// baseline plus its label below.
void drawDendroLeaf(picture pic, pair pos, string labelText, Theme theme) {
    draw(pic, pos--(pos.x, pos.y - dendroTickLen), theme.stroke);
    label(pic, labelText, (pos.x, pos.y - dendroTickLen), S, theme.text);
}

// The elbow connector joining two already-positioned child nodes (leaves or
// earlier merges) into a new merge at height mergeY: a vertical stub from
// each child up to mergeY, then a horizontal bar between them. Returns the
// new node's position -- (midpoint x, mergeY) -- so it can feed into a
// further merge higher up the tree.
pair drawDendroMerge(picture pic, pair leftPos, pair rightPos, real mergeY, Theme theme) {
    draw(pic, leftPos--(leftPos.x, mergeY), theme.edge);
    draw(pic, rightPos--(rightPos.x, mergeY), theme.edge);
    draw(pic, (leftPos.x, mergeY)--(rightPos.x, mergeY), theme.edge);
    return ((leftPos.x + rightPos.x)/2, mergeY);
}

// A vertical axis to the left of the tree, labeled in the original
// (unscaled) distance units -- yScale converts a real distance into the
// plot's y-coordinate, matching whatever scale the diagram script used when
// it precomputed merge-node y-positions.
void drawDendroHeightAxis(picture pic, Theme theme, real xPos, real yMaxDist,
                           real yScale, real tickStep, string axisLabel="distance") {
    draw(pic, (xPos, 0)--(xPos, yMaxDist*yScale), theme.stroke, Arrow(6));
    label(pic, axisLabel, (xPos, yMaxDist*yScale), N, theme.text);
    for (real d = 0; d <= yMaxDist + 1e-9; d += tickStep) {
        real y = d*yScale;
        draw(pic, (xPos - dendroTickLen, y)--(xPos + dendroTickLen, y), theme.stroke);
        label(pic, "$" + format("%.1f", d) + "$", (xPos - dendroTickLen, y), W, theme.text);
    }
}

// A dashed horizontal line marking where the tree is cut into segments,
// spanning from xMin to xMax at height y (already in plot-coordinate scale,
// i.e. distance*yScale).
void drawDendroCutLine(picture pic, Theme theme, real y, real xMin, real xMax, string labelText="") {
    draw(pic, (xMin, y)--(xMax, y), theme.stroke + dashed);
    if (labelText != "") label(pic, labelText, (xMax, y), E, theme.text);
}
