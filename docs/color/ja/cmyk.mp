beginfig(2);
u := 3cm;

path p[];
p[0] := fullcircle scaled 2u shifted (0.75u, 0) rotated 180;
p[1] := p[0] rotated 120;
p[2] := p[1] rotated 120;
cmykcolor c[]; c[0] := (1, 0, 0, 0); c[1] := (0, 1, 0, 0); c[2] := (0, 0, 1, 0);

for i = 0 upto 2:
  fill p[i] withcmykcolor c[i];
endfor;
for i = 0 upto 2:
  fill buildcycle(p[i], p[(i + 1) mod 3]) withcmykcolor c[i] + c[(i + 1) mod 3];
endfor;
fill buildcycle(p[0], p[1], p[2]) withcmykcolor c[0] + c[1] + c[2];
draw(p[0]); draw(p[1]); draw(p[2]);
label(btex 減法混色$^2$ etex scaled 2, (0, -2u));
endfig;
end;
