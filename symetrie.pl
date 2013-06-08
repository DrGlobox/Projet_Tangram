%symetrie(Point, Segment, NouveauPoint)
symetrie([X, Y], [[Ax, Ay], [Bx, By]], [Nx, Ny]) :-
    Nx is X + 2 * (By - Ay),
    Ny is Y + 2 * (Ax - Bx).
