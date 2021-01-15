#This is a query that selects all from the user table and limits the data to the top 20 (It helps save processing time )

SELECT *
From Users 
Limit 20


#Pull a list of user email address but for only non deleted users. Here we see the WHERE and IS NULL used to filter.

SELECT id, email
from users
where deleted_at IS NULL


#Count the number of each items for sale by category. We can use the group by function when we want to aggregate the data, item_count isnt grouped because theres already an aggregation on it. DESC is used to order the item_count by from largest to smallest.

SELECT category, count(*) as item_count 
FROM Items 
group by  1
order by 2 DESC 


#Joining two tables together. Join here represents (inner join). The AS is used to create an alias for tables and ON is the fucking used to join the tables on an identical key. 

Select *
from Users as a
JOIN Orders as b
ON a.id = b.user_id


#Count the number of viewed_items as events. If we used a regualr COUNT it would have given us an answer, however with count distinct we have the exact count of unique values. 

Select count (distinct event_id) as events 
from Events 
Where event_name = 'view_item'


#Count the number of items that have beeen ordered

SELECT Count(distinct item_id) as item count
from order as 


#Find out if a user made an order, when was the first purchase. 

SELECT user.id as user_id, 
MIN(orders.paid_at) AS min_paid_at 
from users as u
left outer join orders as o 
on u.id = o.user_id
group by 1 
order by 2 ASC 


#Find out the percentage of users that have view the profile page

SELECT (CASE WHEN first_view IS NULL then false else true END) AS has_viewed profile_page 
Count (user_id) as users
from 
(SELECT users.id as user_id, 
MIN(event_time) as first_view
 from 
 Users as u
 left outer join 
 Events as e 
 on e.user_id = u.id 
 and e.event_name = 'view_user_profile'
 Group by 
 u.id) first_profile_views 
 Group by 
 (Case When first_view is NULL then false else true end)
