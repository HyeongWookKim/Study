  /* Student Activity 12 */
	/*The first set of code here reflects what is covered
	in the course notes */
data one;
input X $ A $;
cards;
1	a
1	a
1	b
2	c
3	v
4	e
6	g
;


data two; 
input X $ B $;
cards;
1	x
2	y
3	z
3	v
5	w
;

proc sql;
select *
   from one
intersect all
select *
   from two;
quit;


  /* The data here has been modified so that there is one common, yet duplicated,
		row in each table (values of 1 a).  The addition of the ALL modifier prevents
		duplicates from being deleted */

data one;
input X $ A $;
cards;
1	a
1	a
1	b
2	c
3	v
4	e
6	g
;


data two; 
input X $ B $;
cards;
1	a
1   a
2	y
3	z
3	v
5	w
;

proc sql;
select *
   from one
intersect all
select *
   from two;
quit;
