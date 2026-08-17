// unsupervised_assocrules_customers.asy
// Association rules mined from the same 9 customer baskets as
// unsupervised_hclust_customers.asy (see unsupervised_customer_data.asy),
// illustrating how the item co-occurrences behind that clustering also
// show up directly as rules.
//
// Derivation (support/confidence/lift over the 9 baskets -- computed
// offline, not recomputed here):
//   {Beer} -> {Chips}:        support=0.556 confidence=1.000 lift=1.800
//   {Diapers} -> {Milk}:      support=0.333 confidence=1.000 lift=1.800
//   {Bread,Milk} -> {Eggs}:   support=0.222 confidence=0.500 lift=1.500
// The first two are perfect-confidence rules, one from each customer
// segment found by the dendrogram (snacks/beer, family/staples); the third
// is a weaker, partial-confidence rule shown for contrast.

import unsupervised_theme;
import unsupervised_rules;

void drawAssocRulesDiagram(picture pic, Theme theme) {
    real antX = 1.5;
    real consX = 6.5;

    drawRule(pic, (antX, 7), new string[] {"Beer"},
                  (consX, 7), new string[] {"Chips"},
                  theme, 0.556, 1.000, 1.800);
    label(pic, "snacks/beer segment", (antX, 7 - 0.9), theme.text);

    drawRule(pic, (antX, 4), new string[] {"Diapers"},
                  (consX, 4), new string[] {"Milk"},
                  theme, 0.333, 1.000, 1.800);
    label(pic, "family/staples segment", (antX, 4 - 0.9), theme.text);

    drawRule(pic, (antX, 1), new string[] {"Bread","Milk"},
                  (consX, 1), new string[] {"Eggs"},
                  theme, 0.222, 0.500, 1.500);
    label(pic, "weaker signal (partial confidence)", (antX, 1 - 0.9), theme.text);
}

void renderAssocRulesDiagram(pen background, pen foreground) {
    Theme theme = newTheme(background, foreground);
    picture pic;
    drawAssocRulesDiagram(pic, theme);
    renderTheme(pic, theme);
}

renderAssocRulesDiagram(black, white);
