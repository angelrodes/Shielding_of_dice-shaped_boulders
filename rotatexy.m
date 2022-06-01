function out = rotatexy(x,y,angle);
ang=-angle/360*2*pi;
rx=x*cos(ang)-y*sin(ang);
ry=y*cos(ang)+x*sin(ang);
out.rx=rx;
out.ry=ry;