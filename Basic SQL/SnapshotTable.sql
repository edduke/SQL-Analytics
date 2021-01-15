#Snapshot table is a useful way to segment users into useful groups for analysis. good tool to get pre event data. 

#Firstly create a the user table

CREATE TABLE IF NOT EXISTS user_info
(
user_id             INT(10)       NOT NULL,
created_today       INT(1)        NOT NULL,
is_deleted          INT(1)        NOT NULL,
is_deleted_today    INT(1)        NOT NULL,
has_ever_ordered    INT(1)        NOT NULL,
ordered_today       INT(1)        NOT NULL,
ds                  DATE          NOT NULL
);

DESCRIBE user_info;

 
INSERT INTO user_info 


{% assign ds = '2021-01-15' %}   #Fun function to def a assign date to a variable 
Select
id AS user_id
IF(users.created_at = '{{ds}}' , 1,0) AS created_today,
IF(user.deleted_at <= '{{ds}}' , 1,0) AS is_deleted,
IF(users.deleted_at = '{{ds}}' , 1,0) AS is_deleted_today,
IF(users_with_orders.user.id IS NOT NULL, 1, 0) AS ordered_today,
'{{ds}}'  AS ds
FROM 
users
LEFT OUTER JOIN 
( 
SELECT 
DISTINCT user_id
FROM
orders
WHERE
created_at <= '{{ds}}' 
AND '{{ds}}' >= date_add(CURDATE(), INTERVAL -1 month)   #Partitioning your data by date will safe processing and time, helps to avoid a full table scan 
) users_with_orders
ON 
users_with_orders.user_id = users.id 
LEFT OUTER JOIN 
(
SELECT
DISTINCT user_id
FROM 
orders
WHERE
created_at = {{ds}}
 AND '{{ds}}' >= date_add(CURDATE(), INTERVAL -1 month)
) users_with_orders_today
ON
users_with_orders_today.user.id = users.id
WHERE
users.created_ at <= '{{ds}}'

'{{ds}}' AS variable_column 
from users
where
created_at <= '{{ds}}'
AND '{{ds}}' >= date_add(CURDATE(), INTERVAL -1 month)



#This is a query for a quick business question of 'how many users have ordered a skateboard'
SELECT
orders.item_category,  #Adding something extra to anticipate follow up questions
COUNT(DISTINCT 
      COALESCE(parent_user_id, user_id)) as users_with_orders   #To avoid duplicate users incase you dont want to count both parent and user
               From 
               Orders
               Join
               Users
               On
               users.id = orders.user_id
               WHERE orders.item_category = 'skateboard'
               GROUP BY orders.item_category 

