// unsupervised_common.asy
// Shared drawing primitives for unsupervised-learning scatter-plot diagrams:
// axes, raw data points, cluster-labeled points, centroids, and a
// generalized cluster legend. Every function takes a Theme (see
// unsupervised_theme.asy) so the same code renders identically in light and
// dark variants.
//
// Style and layout constants (axes, point sizing, legend spacing) are
// ported from supervised-visualization/supervised_common.asy; point and
// legend drawing are generalized from a fixed two-class scheme to an
// arbitrary number of clusters, since clustering methods don't fix K at 2
// the way the binary-classification examples did.

import unsupervised_theme;

// --- Shared style constants
real r            = 0.22;  // cluster-point radius
real rawR         = 0.09;  // raw/unclustered data-point radius (small dot)
real diamondScale = 1.4;   // centroid half-diagonal relative to r
int  axisMax      = 9;
real yMax          = 7.5;
int  xTicks        = 8;    // number of x-axis tick marks
int  yTicks        = 7;    // number of y-axis tick marks
real tickLen       = 0.12;
real legStep        = 0.75; // vertical spacing between legend entries
real legTextGap     = 0.1;  // gap between legend symbol and text

// --- Helper functions

path diamond(pair center, real half) {
    return (center+(0,half)) -- (center+(half,0))
        -- (center+(0,-half)) -- (center+(-half,0)) -- cycle;
}

// A plain, unlabeled data point -- for "before clustering" scatter plots
// where no cluster assignment exists yet.
void drawDataPoint(picture pic, pair pos, Theme theme, real radius=rawR) {
    filldraw(pic, circle(pos, radius), theme.stroke, theme.stroke);
}

// A point labeled with its cluster id (1, 2, 3, ...) -- generalizes the
// fixed "class 1" / "class 2" point styles to an arbitrary number of
// clusters, since K is a parameter here rather than fixed at 2.
void drawClusterPoint(picture pic, pair pos, int clusterId, Theme theme, real radius=r) {
    pen border = theme.stroke + linewidth(1pt);
    filldraw(pic, circle(pos, radius), theme.nodeFill, border);
    label(pic, "$" + string(clusterId) + "$", pos, theme.text + fontsize(12 * radius/r));
}

// A cluster centroid -- a diamond marker, optionally labeled with the id of
// the cluster it centers (e.g. to link a centroid to its points in a
// k-means diagram).
void drawCentroid(picture pic, pair pos, Theme theme, string labelText="", real half=r*diamondScale) {
    pen border = theme.stroke + linewidth(1.2pt);
    filldraw(pic, diamond(pos, half), theme.nodeFill, border);
    if (labelText != "") label(pic, labelText, pos, theme.text);
}

void drawAxes(picture pic, Theme theme, string xLabel="$x_1$", string yLabel="$x_2$") {
    draw(pic, (0,0)--(axisMax,0), theme.stroke, Arrow(6));
    draw(pic, (0,0)--(0,yMax), theme.stroke, Arrow(6));
    label(pic, xLabel, (axisMax, 0), E, theme.text);
    label(pic, yLabel, (0, yMax), N, theme.text);

    for (int i = 1; i <= xTicks; ++i) {
        draw(pic, (i,-tickLen)--(i,tickLen), theme.stroke);
        label(pic, "$" + string(i) + "$", (i, -tickLen), S, theme.text);
    }
    for (int j = 1; j <= yTicks; ++j) {
        draw(pic, (-tickLen,j)--(tickLen,j), theme.stroke);
        label(pic, "$" + string(j) + "$", (-tickLen, j), W, theme.text);
    }
}

// Draws a numbered legend entry per cluster label, followed by an optional
// centroid entry, starting at `start`. Returns the position of the next
// legend slot below, so diagram scripts can append further entries (e.g. a
// noise/outlier marker for DBSCAN) after calling this.
pair drawClusterLegend(picture pic, Theme theme, pair start, string[] labels,
                        bool includeCentroid=false, string centroidLabel="centroid") {
    pair pos = start;
    for (int i = 0; i < labels.length; ++i) {
        drawClusterPoint(pic, pos, i + 1, theme);
        label(pic, labels[i], pos + (r + legTextGap, 0), E, theme.text);
        pos = pos + (0, -legStep);
    }
    if (includeCentroid) {
        real half = r * diamondScale;
        drawCentroid(pic, pos, theme);
        label(pic, centroidLabel, pos + (half + legTextGap, 0), E, theme.text);
        pos = pos + (0, -legStep);
    }
    return pos;
}
