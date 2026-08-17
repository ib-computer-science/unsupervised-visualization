// unsupervised_assocrules_customers.asy
// Association rules mined from the same 9 customer baskets as
// unsupervised_hclust_customers.asy (see unsupervised_customer_data.asy),
// illustrating how the item co-occurrences behind that clustering also
// show up directly as rules -- and, via the first two rules, that a rule's
// direction matters (confidence is not symmetric even though lift is).
//
// Derivation (support/confidence/lift over the 9 baskets -- computed
// offline, not recomputed here):
//   {Applesauce} -> {Milk}:   support=0.333 confidence=1.000 lift=1.800
//   {Milk} -> {Applesauce}:   support=0.333 confidence=0.600 lift=1.800
//   {Bread,Milk} -> {Eggs}:   support=0.222 confidence=0.500 lift=1.500
// The first two rules are the same item pair in both directions: support
// and lift are identical either way (lift is direction-symmetric by
// construction), but confidence isn't -- Applesauce is bought by fewer
// customers than Milk, so "given Applesauce, how often also Milk" (3/3) is
// higher than "given Milk, how often also Applesauce" (3/5). The third rule
// is a weaker, partial-confidence rule shown for further contrast.

import unsupervised_theme;
import unsupervised_rules;

void drawAssocRulesDiagram(picture pic, Theme theme) {
    real antX = 1.5;
    real consX = 6.5;

    drawRule(pic, (antX, 7), new string[] {"Applesauce"},
                  (consX, 7), new string[] {"Milk"},
                  theme, 0.333, 1.000, 1.800);
    label(pic, "rarer item first: high confidence", (antX, 7 - 0.9), theme.text);

    drawRule(pic, (antX, 4), new string[] {"Milk"},
                  (consX, 4), new string[] {"Applesauce"},
                  theme, 0.333, 0.600, 1.800);
    label(pic, "same pair, reversed: confidence drops", (antX, 4 - 0.9), theme.text);

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
