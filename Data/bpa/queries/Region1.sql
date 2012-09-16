﻿select gid, sta_code, name, type, owner, st_askml(the_geom) 
from 
	bpasubstations, 
	ST_MakePolygon(ST_GeomFromText(
		'LINESTRING(-121.3067760056749 48.7166891317276, -123.2033484801255 49.0403356307321, -124.2777614908601 48.45212178787259, -124.4208800918233 47.96174622004535, -124.1794156059421 47.13392216130518, -124.1752139736363 46.66842676227466, -124.0676028817038 46.30283767599884, -123.4624695416749 46.28477690524837, -123.1230362868447 46.1921631166618, -123.0960792350328 46.0839207690743, -123.0444561638196 46.00458321182722, -122.9182830524227 45.96615768445729, -122.6920790222164 45.85445210290583, -122.5173281979891 45.7819418160506, -122.3105241374994 45.77784268337998, -122.0067909945675 45.83011475185218, -121.7185268273009 45.89882620665432, -121.2943065336102 45.7671562512668, -121.3067760056749 48.7166891317276)',
		4269
		)) as r1
	
where ST_Contains( r1, the_geom) 