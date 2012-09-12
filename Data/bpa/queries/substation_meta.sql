
select COUNT(gid) as count, owner from bpasubstations group by owner order by count desc