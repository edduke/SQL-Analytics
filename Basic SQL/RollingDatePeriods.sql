#A rolling count gives us the ablitlty to compare to past data but the comparison is more fair, its easier to see if the trend is going up or down based on the date ranges

#Create a Subtable of orders by day

SELECT dates_rollup.date,
COALESCE(SUM(orders), 0)            AS orders,
COALESCE(SUM(items_ordered), 0)     AS items_ordered 
From
dates_rollup
LEFT OUTER JOIN
(
Select
date(orders.paid_at) AS day, 
COUNT(DISTINCT invoice-id) AS orders, 
COUNT(DISTINCT line_item_id) AS line_items
From 
Orders
Group by
date(orders.paid_at) 
) daily_orders
ON
daily_orders.day = dates_rollup.date
