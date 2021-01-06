#Question 1. Turnover = sum of the orderlines 'price_et' + 'shipping_price_et' of the corresponding orders(cancellations included). Over all orders, what portion of the turnover #does the shipping represent? Do not take VAT in account. Your answer must be a percentage rounded to the second decimal. 

With records as 
(
select price_et * (1 - vat_rate) as price_before_tax,
shipping_price_et * (1 - shipping_vat_rate) as shipping_price_before_tax
from order_lines as ol
join orders as o
on ol.order_id = o.id
left join order_line_cancellations AS c
on ol.cancellation_id = c.id
),
shipping as 
(
select sum(shipping_price_before_tax)/ (SUM(price_before_tax + shipping_price_before_tax)) as shipping_percent
from records )
select trim(to_char(shipping_percent * 100, '99999999999999999D99')) AS shipping_vat_free
from shipping

#Question 2. Which percentage of the orders paid between April 1st and September 30 were Cancelled? Your answer must be a percentage, rounded to the closet integer. 

With cancellers as 
(
Select (CAST( count(ol.id) as decimal(10,2))) as  total_cancel
from order_lines as ol
join orders as o
on ol.order_id = o.id
where o.paid_at between '2020-04-01' and '2020-09-30'
and ol.cancellation_id IS NOT NULL
), 
par as 
(
select
count(ol.id),
(total_cancel / (count(ol.id))) * 100 as total_cancels
from cancellers, orders as ol
where ol.created_at between '2020-04-01' and '2020-09-30'
group by cancellers.total_cancel
)
select
round(total_cancels) as total_cancels_
from par

#Question 3. During the month of April, what was the average shopping cart? (a shopping cart is the sum of the prices od the order lines for a given order, including taxes and #including shipping). Your answer must be a number, rounded to the closest integer. 

SELECT round(total_shopping_cart/total_num) as avg_cart
from
(
select sum(ol.price_et +o.shipping_price_et) as total_shopping_cart
count(ol.id) as total_num
from order_lines as ol
join orders as o
on o.id = ol.order_id
where ol.created_at between '2020-04-01' and '2020-04-30'
and o.created_at between '2020-04-01' and '2020-04-30'
) as foo

#Question 4. What was the turnover excluding taxes but including shipping, during the month of July 2020? You must here count the turnover based on all orders with 'paid_at' #within the month of july 2020 (cancellations included). Your answer must be a number, rounded to the closet integer. 

With records as
(
select ol.price_et * (1 - ol.vat_rate) as price_before_tax,
o.shipping_price_et * (1 - o.shipping_vat_rate) as shipping_price_before_tax
from order_lines as ol
join entry_tests.orders as o
on ol.order_id = o.id
full join entry_tests.order_line_cancellations AS c
on ol.cancellation_id = c.id
and o.paid_at between '2020-07-01' and '2020-07-31'
),
shipping as (
select SUM(price_before_tax + shipping_price_before_tax) as shipping_percent
from records )
select round((shipping_percent/count(o.id))) as num
from shipping, orders as o
group by shipping_percent

#Question 5. Overall, which week had the highest turover? the answer must be the Monday of the corresponding week, formatted as YYYY-MM-DD

SELECT cast(ol.created_at as date ) as date_,
sum(ol.price_et + o.shipping_price_et) as turnover
from order_lines as ol
join orders as o
on ol.order_id = o.id
group by ol.created_at
order by turnover desc
