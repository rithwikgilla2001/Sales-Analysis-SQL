------------Sellers city percentage---------------

with t1 as 
(
	select concat(seller_city, ', ', seller_state) as seller_city_state, 
	count(seller_city) as seller_cnt_city
	from sellers
	group by seller_city_state
	having count(seller_city) > 30
	order by seller_cnt_city desc
)

select seller_city_state, 
seller_cnt_city, 
round((seller_cnt_city/sum(seller_cnt_city) over())*100,2) as perc_city_loc
from t1

------------Late delivery orders percentage---------------

select round((sum(late_delivery)*1.0/count(order_id))*100,2) as late_del_perc
from
(
select *,
case when order_status = 'delivered' 
and order_estimated_delivery_date <= order_delivered_customer_date then 1
else 0 end as late_delivery
from orders
)

------------Highest revenue generating products---------------

select product_category, round(sum(price+freight_value)) as tot_val
from order_items
join products
on order_items.product_id = products.product_id
group by product_category
order by tot_val desc

------------Sales across quarters---------------

SELECT
    EXTRACT(YEAR FROM order_delivered_customer_date) AS year,
    SUM(CASE WHEN EXTRACT(QUARTER FROM order_delivered_customer_date) = 1 THEN price + freight_value ELSE 0 END) AS q1,
    SUM(CASE WHEN EXTRACT(QUARTER FROM order_delivered_customer_date) = 2 THEN price + freight_value ELSE 0 END) AS q2,
    SUM(CASE WHEN EXTRACT(QUARTER FROM order_delivered_customer_date) = 3 THEN price + freight_value ELSE 0 END) AS q3,
    SUM(CASE WHEN EXTRACT(QUARTER FROM order_delivered_customer_date) = 4 THEN price + freight_value ELSE 0 END) AS q4
FROM
    orders
JOIN
    order_items ON orders.order_id = order_items.order_id
WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM order_delivered_customer_date)
ORDER BY
    EXTRACT(YEAR FROM order_delivered_customer_date);

------------Customer concentration---------------

select customer_state, count(customer_id) as cnt_cust
from customers
group by customer_state
order by cnt_cust desc

------------Preferred Payment methods---------------

select payment_type, count(payment_type) as cnt_pay
from payments
group by payment_type
order by cnt_pay desc

------------Delivery days---------------

with t1 as 
(
select *,
(order_estimated_delivery_date-order_purchase_timestamp) as est_days,
(order_delivered_customer_date-order_purchase_timestamp) as del_days,
case when (order_delivered_customer_date-order_purchase_timestamp) > (order_estimated_delivery_date-order_purchase_timestamp) then 'Late_del' 
when (order_delivered_customer_date-order_purchase_timestamp) < (order_estimated_delivery_date-order_purchase_timestamp) then 'Fast_del'
else 'Normal_del' end as Type_ord
-- sum(price+freight_value) as tot_val
from orders
join order_items
on orders.order_id = order_items.order_id
join products
on order_items.product_id = products.product_id
where order_status = 'delivered' 
)

select *
-- order_id,customer_id,order_item_id, seller_id, product_category
from t1