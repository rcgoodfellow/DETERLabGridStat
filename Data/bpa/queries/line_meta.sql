﻿select COUNT(gid) as count, owner from bpalines group by owner order by count desc