13. update shop_products
set unit_price = unit_price * 1.1
where product_title_id in (
    select product_title_id
    from product_titles
    where product_category_id IN (
        select category_id
        from product_categories
        where category_name = 'grocery'
    )
)

14.
select person_first_name || '   ' || person_last_name as 	fullname,avg((price_with_discount::decimal)*product_amount) as avg_sum from 	customer_order_details
join customer_orders using(customer_order_id)
join customers using(customer_id)
join persons on customers.customer_id=persons.person_id
group by person_id
having avg((price_with_discount::decimal)*product_amount)>200000
order by avg((price_with_discount::decimal)*product_amount) desc,fullname asc	
	
15.
select *
	from persons
	where person_birth_date between '2000-01-01' and '2005-12-31';
16.
-- delete from shop_products
-- where product_title_id in (
--     select product_title_id
--     from product_titles
--     where product_category_id IN (
--         select category_id
--         from product_categories
--         where category_name = 'drinks'
--     )
-- );
17.
	do $$ 
declare
    v_manufacturer_id INT;
    v_supplier_id INT;
    v_category_id INT;
    v_product_title_id INT;
begin
    select manufacturer_id INTO v_manufacturer_id
    from product_manufacturers
    where manufacturer_name = 'Coca-cola company';

    select supplier_id INTO v_supplier_id
    from product_suppliers
    where supplier_name = 'Pepsi Supplier'; 

    select category_id INTO v_category_id
    from product_categories
    where category_name = 'Drinks';

    insert into product_titles (product_title, product_category_id)
    values ('Pepsi', v_category_id)
    returning product_title_id INTO v_product_title_id;

    insert into shop_products (product_title_id, product_manufacturer_id, product_supplier_id, unit_price, comment)
    values (v_product_title_id, v_manufacturer_id, v_supplier_id, '$1.99', 'New product: Pepsi');

    commit;
 18.
select
  product_title_id,
  comment,
  case
    when unit_price::decimal < 300 then 'very cheap'
    when unit_price::decimal > 300 and unit_price::decimal <= 750 then 'affordable'
    ekse 'expensive'
  END as type
from  shop_products;
19.
select supermarket_id,supermarket_name,count(distinct product_id)
from supermarkets
join supermarket_locations using(supermarket_id)
join customer_orders using(supermarket_location_id)
join customer_order_details using(customer_order_id)
group by(supermarket_id)

20.
create or replace function getProductListByOperationDate(operationDate DATE)
returns table (
    product_title VARCHAR(255),
    unit_price MONEY,
    product_amount INT
) as $$
begin
    return query
    select
        pt.product_title,
        sp.unit_price,
        cod.product_amount
    from
        customer_orders co
    join customer_order_details cod ON co.customer_order_id = cod.customer_order_id
    join shop_products sp ON cod.product_id = sp.product_id
    join product_titles pt ON sp.product_title_id = pt.product_title_id
    where
        co.operation_time::DATE = operationDate;
END;
$$ LANGUAGE plpgsql;
21.

-- drop function getcustomerlistformanufacturer(character varying);
-- create or replace function getCustomerListForManufacturer(manufacturer_param VARCHAR)
-- returns table (
--     customer_id INT,
--     person_first_name VARCHAR(255),
--     person_last_name VARCHAR(255),
--     card_number VARCHAR(16),
--     discount INT
-- ) AS $$
-- BEGIN
--     return query
--     seelct
--         c.customer_id,
--         p.person_first_name,
--         p.person_last_name,
--         c.card_number,
--         c.discount
--     from
--         customers c
--     join persons p ON c.person_id = p.person_id
--     join customer_orders co ON c.customer_id = co.customer_id
--     join shop_products sp ON co.customer_order_id = sp.product_id
--     join product_manufacturers pm ON sp.product_manufacturer_id = pm.manufacturer_id
--     where
--         pm.manufacturer_name = manufacturer_param;
-- END;
-- $$ LANGUAGE plpgsql;
22.
-- create or replace function GetSalesRevenueOfGivenCity(city_name VARCHAR, country_name VARCHAR)
-- returns money AS $$
-- declare
--     total_revenue money;
-- BEGIN
--     select COALESCE(SUM(cod.price_with_discount * cod.product_amount), 0)
--     into total_revenue
--     from customer_orders co
--     join supermarket_locations sl ON co.supermarket_location_id = sl.supermarket_location_id
--     join locations l ON sl.location_id = l.location_id
--     join location_city lc ON l.location_city_id = lc.city_id
--     join customer_order_details cod ON co.customer_order_id = cod.customer_order_id
--     where lc.city = city_name AND lc.country = country_name;

--     return total_revenue;
-- END;
-- $$ LANGUAGE plpgsql;
23.
-- create or replace view Checkout AS
-- select
--     c.customer_id,
--     CONCAT(p.person_first_name, ' ', p.person_last_name) AS customer_full_name,
--     pt.product_title,
--     cod.price_with_discount,
--     cod.product_amount,
--     (cod.price_with_discount * cod.product_amount) AS total_payment
-- from
--     customers c
-- join persons p ON c.person_id = p.person_id
-- join customer_orders co ON c.customer_id = co.customer_id
-- join customer_order_details cod ON co.customer_order_id = cod.customer_order_id
-- join shop_products sp ON cod.product_id = sp.product_id
-- join product_titles pt ON sp.product_title_id = pt.product_title_id;
-- select * from getCustomerListForManufacturer('Creator name');
-- 24.
-- select * from getProductListByOperationDate('2005-02-27');
-- create view product_details  as
-- select pt.product_title, pc.category_name, sup.supplier_name, pm.manufacturer_name  
-- from shop_products as sp inner join product_titles as pt
-- on sp.product_title_id=pt.product_title_id inner join product_categories as pc
-- on pt.product_category_id = pc.category_id inner join product_suppliers as sup on 
-- sp.product_supplier_id=sup.supplier_id inner join product_manufacturers as pm on
-- sp.product_manufacturer_id = pm.manufacturer_id

--25
-- create view Customer_details as
-- 	select person_first_name|| ' ' || person_last_name as Full_name,
-- 	person_birth_date, cu.card_number
-- 	from persons inner join customers as cu on person_id=customer_id

-- END $$;
