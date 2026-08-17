// unsupervised_basket_matrix_customers.asy
// The raw simulated data behind unsupervised_hclust_customers.asy and
// unsupervised_assocrules_customers.asy: which of the 9 customers bought
// which of the 6 catalog items (see unsupervised_customer_data.asy for the
// basket table). Shown as a binary matrix rather than a scatter plot, since
// the underlying data is itself a binary customer x item table, not points
// in a continuous space.
//
// Rows are the 6 items in alphabetical order; columns are the 9 customers
// in numerical order -- a plain, look-up-friendly ordering, rather than one
// grouped to make the two purchasing segments read as contiguous blocks
// (contrast unsupervised_hclust_customers.asy, which orders customers by
// the dendrogram's leaf order for exactly that grouping effect).

import unsupervised_theme;

real cellSize = 1;

string[] rowLabels = {"Applesauce","Beer","Bread","Chips","Eggs","Milk"};
string[] colLabels = {"$C_1$","$C_2$","$C_3$","$C_4$","$C_5$",
                       "$C_6$","$C_7$","$C_8$","$C_9$"};

// purchased[row][col], in the row/column order above
bool[][] purchased = {
    {false, false, false, false, false, true,  false, true,  true },  // Applesauce
    {false, true,  true,  true,  true,  false, true,  false, false},  // Beer
    {true,  false, true,  false, true,  false, true,  true,  true },  // Bread
    {false, true,  true,  true,  true,  false, true,  false, false},  // Chips
    {true,  false, false, false, false, true,  false, true,  false},  // Eggs
    {true,  false, false, false, true,  true,  false, true,  true }   // Milk
};

pair cellCorner(int row, int col) {
    return (col*cellSize, (rowLabels.length - 1 - row)*cellSize);
}

void drawBasketMatrix(picture pic, Theme theme) {
    for (int r = 0; r < rowLabels.length; ++r) {
        for (int c = 0; c < colLabels.length; ++c) {
            pair corner = cellCorner(r, c);
            path cell = box(corner, corner + (cellSize, cellSize));
            filldraw(pic, cell, theme.nodeFill, theme.stroke);
            if (purchased[r][c])
                label(pic, "$\times$", corner + (cellSize/2, cellSize/2), theme.text);
        }
        label(pic, rowLabels[r], cellCorner(r, 0) + (0, cellSize/2), W, theme.text);
    }
    for (int c = 0; c < colLabels.length; ++c) {
        pair topCorner = cellCorner(0, c);
        label(pic, colLabels[c], topCorner + (cellSize/2, cellSize), N, theme.text);
    }
}

void renderBasketMatrix(pen background, pen foreground) {
    Theme theme = newTheme(background, foreground);
    picture pic;
    drawBasketMatrix(pic, theme);
    renderTheme(pic, theme);
}

renderBasketMatrix(black, white);
