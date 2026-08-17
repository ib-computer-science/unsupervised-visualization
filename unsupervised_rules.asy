// unsupervised_rules.asy
// Drawing primitives for association-rule diagrams: item boxes, itemsets
// (rows of item boxes for an antecedent or consequent), and a rule arrow
// connecting an antecedent itemset to a consequent itemset annotated with
// support/confidence/lift. Every function takes a Theme (see
// unsupervised_theme.asy) so the same code renders identically in light and
// dark variants.

import unsupervised_theme;

real itemBoxW = 1.6;
real itemBoxH = 0.7;
real itemGap  = 0.15;

// A single item, drawn as a labeled box centered at pos.
void drawItemBox(picture pic, pair pos, string itemName, Theme theme) {
    path b = box(pos - (itemBoxW/2, itemBoxH/2), pos + (itemBoxW/2, itemBoxH/2));
    filldraw(pic, b, theme.nodeFill, theme.stroke);
    label(pic, itemName, pos, theme.text);
}

// A horizontal row of item boxes (an antecedent or consequent itemset)
// centered at centerPos. Returns {leftAnchor, rightAnchor} -- the
// midpoints of the row's left and right edges -- so a rule arrow can attach
// to whichever side faces the other itemset.
pair[] drawItemset(picture pic, pair centerPos, string[] itemNames, Theme theme) {
    int n = itemNames.length;
    real totalW = n*itemBoxW + (n-1)*itemGap;
    real xStart = centerPos.x - totalW/2 + itemBoxW/2;
    for (int i = 0; i < n; ++i) {
        pair pos = (xStart + i*(itemBoxW + itemGap), centerPos.y);
        drawItemBox(pic, pos, itemNames[i], theme);
    }
    pair left = (centerPos.x - totalW/2, centerPos.y);
    pair right = (centerPos.x + totalW/2, centerPos.y);
    return new pair[] {left, right};
}

// A full rule: antecedent itemset -> consequent itemset, connected by an
// arrow from the antecedent's right edge to the consequent's left edge,
// labeled with support/confidence/lift above the arrow.
void drawRule(picture pic, pair antecedentCenter, string[] antecedentItems,
              pair consequentCenter, string[] consequentItems, Theme theme,
              real support, real confidence, real lift) {
    pair[] antAnchors = drawItemset(pic, antecedentCenter, antecedentItems, theme);
    pair[] consAnchors = drawItemset(pic, consequentCenter, consequentItems, theme);
    pair fromPt = antAnchors[1];
    pair toPt = consAnchors[0];
    draw(pic, fromPt--toPt, theme.edge, Arrow(6));
    string stats = "supp=" + format("%.2f", support)
                 + ", conf=" + format("%.2f", confidence)
                 + ", lift=" + format("%.2f", lift);
    pair mid = (fromPt + toPt)/2;
    label(pic, stats, (mid.x, mid.y + itemBoxH/2 + 0.15), N, theme.text);
}
