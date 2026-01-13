unitsize(2cm);

path[] p = new path[3];
p[0] = rotate(180) * shift(0.75, 0) * unitcircle;
p[1] = rotate(120) * p[0];
p[2] = rotate(120) * p[1];
pen[] c = {cmyk(1,0,0,0), cmyk(0,1,0,0), cmyk(0,0,1,0)};

for (int i: sequence(3))
  fill(p[i], c[i]);
for (int i: sequence(3))
  fill(buildcycle(p[i], p[(i + 1) % 3]), c[i] + c[(i + 1) % 3]);
fill(buildcycle(... p), c[0] + c[1] + c[2]);
draw(p);
label((0, -2), "{\sffamily 減法}混色$^2$", fontsize(16pt));
