// unsupervised_theme.asy
// Color theme definitions shared by all unsupervised-learning visualization
// diagrams (clustering, association rules). Every diagram is strictly
// two-tone -- a background pen and a foreground pen -- via a single Theme
// struct that every drawing primitive consults instead of hardcoding pens.
// Swapping which pen is passed as background and which as foreground is
// what turns a diagram from black-on-white to white-on-black.
//
// Ported from ann-visualization/anns_theme.asy.

struct Theme {
    pen background;   // canvas background
    pen stroke;        // default line/outline color
    pen nodeFill;      // default node/point fill
    pen text;           // label color
    pen edge;            // connection line color

    void operate(void f(pen)) {}
}

// Builds a Theme from the two pens a diagram actually varies between light
// and dark output. nodeFill mirrors background (points/nodes read as
// "holes" cut into the background) and stroke/text mirror foreground (ink).
// edge is foreground mixed two-thirds of the way toward background, so
// connection lines (e.g. dendrogram merges) read as secondary to point
// outlines and labels without introducing a third, unrelated color --
// keeping every diagram strictly two-tone.
Theme newTheme(pen background, pen foreground) {
    Theme t = new Theme;
    t.background = background;
    t.stroke = foreground;
    t.nodeFill = background;
    t.text = foreground;
    t.edge = 0.3*background + 0.7*foreground;
    return t;
}

// Renders the current picture to disk with the theme's background baked in,
// using shipout(bbox(...)) so exported bitmaps aren't left transparent. No
// filename is passed to shipout, so Asymptote falls back to its own default
// (the calling script's base name). `unit` fixes the physical size of one
// drawing-coordinate unit (default 1cm), since diagrams are laid out in
// plain coordinate units and would otherwise be shipped out at native point
// scale (1 unit = 1bp) and come out illegibly small.
void renderTheme(picture pic, Theme theme, real margin=6, real unit=1cm) {
    unitsize(pic, unit);
    frame f = bbox(pic, margin, margin, invisible, Fill(theme.background));
    shipout(f);
}
