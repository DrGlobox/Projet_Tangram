IsPtInPoly = function(Ax,Ay, index,nb)
{
	var lCrossings = 0

	for(var lLoopCtrl = 0; lLoopCtrl < nb; )
	{
		var Xl = Pt2D_x[index+lLoopCtrl] //on prend le point courant comme 1er point
		var Yl = Pt2D_y[index+lLoopCtrl]

		if(!(lLoopCtrl + 1 > nb - 1))//si le point n'est pas le dernier
		{
			var Xr = Pt2D_x[index+lLoopCtrl + 1]//on prend le point suivant comme 2eme point
			var Yr = Pt2D_y[index+lLoopCtrl + 1]
		}
		else //sinon on prend le 1er point comme 2eme point
		{
			Xr = Pt2D_x[index]
			Yr = Pt2D_y[index]
		}

		if((Xl < Ax) && (Xr < Ax)) { lLoopCtrl++; continue }
		if((Xl > Ax) && (Xr > Ax)) { lLoopCtrl++; continue }
		if((Yl < Ay) && (Yr < Ay)) { lLoopCtrl++; continue }

		if(((Yl > Ay) && (Yr > Ay)) && ((Xl > Ax) || (Xr > Ax)))
		{
			lCrossings++//croise le polygone 1X
			lLoopCtrl++
			continue
		}
		//If it makes it to here then it is in the MBR of the segment
		//We need to test and see which pt is further left in case this was drawn ctr clockwise.
		if(Xl > Xr)
		{
			var temp = Xl
			Xl = Xr
			Xr = temp
			temp = Yl
			Yl = Yr
			Yr = temp
		}

		var Yc = Yl + (((Yr - Yl) / (Xr - Xl)) * (Ax - Xl))
		if(Yc > Ay) lCrossings++//croise le polygone 1X
		lLoopCtrl++
	}

	if((lCrossings % 2) != 0) return true//si le demi-segment croise le polygone un nombre paire de fois
	else return false
} 