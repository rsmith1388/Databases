-- Restraints
Alter Table merchants Add Primary key (mid);
Alter Table products Add Primary key (pid);
Alter Table orders Add Primary key (oid);
Alter Table customers Add Primary key (cid);
Alter Table sell Add Primary key (mid,pid);
Alter Table contain Add Primary key (oid,pid);
Alter Table place Add Primary key (cid,oid);
Alter Table place 
Add constraint place_cid foreign key (cid) references customers(cid),
Add constraint place_oid foreign key (oid) references orders(oid);
Alter Table contain
Add constraint contain_oid foreign key (oid) references orders(oid),
Add constraint contain_pid foreign key (pid) references products(pid);
Alter Table sell 
Add constraint sell_mid foreign key (mid) references merchants(mid),
Add constraint sell_pid foreign key (pid) references products(pid);
Alter Table products
Add constraint product_names Check(name IN ('Printer','Ethernet Adapter','Desktop','Hard Drive','Laptop','Router','Network Card','Super Drive','Monitor'));
Alter Table products
Add constraint product_category Check(category IN ('Peripheral','Networking','Computer'));
Alter Table sell
Add constraint sell_price Check (price >=0 AND price <=100000);
Alter Table sell
Add constraint sell_available Check (quantity_available >=0 AND quantity_available <=1000);
Alter Table orders
Add constraint shipping Check(shipping_method IN ('UPS','FedEx','USPS'));
Alter Table orders
Add constraint cost Check(shipping_cost >= 0 AND shipping_cost <=500);
Alter Table place
Add constraint dates Check(order_date >= '2004-01-01');
-- Restraints

-- Query 1

Select products.name, merchants.name
from products
Join sell ON products.pid = sell.pid      -- Joins the products and sell tables through pid
Join merchants ON sell.mid = merchants.mid        -- Joins the sell and merchants tables through mid
Where sell.quantity_available = 0;     -- Selects the products which are unavailable because the quantity is 0


-- Query 2

Select products.name, products.description
from products
Left Join sell ON products.pid = sell.pid     -- Joins the products and sells tables through pid and includes all products
Where sell.pid is null;        -- Selects the products which are not sold


-- Query 3

Select COUNT(distinct place.cid)     -- Calculates the number of customers who bought SATA drives but not routers
from place
Join contain ON place.oid = contain.oid        -- Joins the contain and place tables through oid
Join products ON contain.pid = products.pid      -- Joins the products and contain tables through pid
Where products.name like 'SATA'
AND cid NOT IN (                       -- Selects the customers who bought SATA drives and checks if they bought a router
Select cid
from place
Join contain ON place.oid = contain.oid      -- Joins the contain and place tables through oid
Join products ON contain.pid = products.pid    -- Joins the products and contain tables through pid
Where products.name like 'Router'     -- Selects customers who bought a router
);

-- Query 4

Select products.name, sell.price * 0.8 AS sale     -- Calculates the sale price after the 20% discount
from products
Join sell ON products.pid = sell.pid        -- Joins the products and sell tables through pid
Join merchants ON sell.mid = merchants.mid          -- Joins the merchants and sell tables through mid
Where merchants.name = 'HP' AND products.category = 'Networking';     -- Selects the products that are made by HP and fall under the Networking category

-- Query 5

Select products.name, sell.price
from customers
Join place ON customers.cid = place.cid        -- Joins the place and customers tables through cid
Join contain ON place.oid = contain.oid        -- Joins the place and contain tables through oid
Join products ON contain.pid = products.pid        -- Joins the products and contain tables through pid
Join sell ON products.pid = sell.pid          -- Joins the products and sell tables through pid
Join merchants ON sell.mid = merchants.mid     -- Joins the merchants and sell tables through mid
Where customers.fullname = 'Uriel Whitney' AND merchants.name = 'Acer';     -- Selects the products purchased by Uriel Whitney from Acer

-- Query 6

Select merchants.name, SUM(sell.price) AS revenue, year(place.order_date) AS year    -- Calculates annual total sales for each merchant
from merchants
Join sell ON merchants.mid = sell.mid          -- Joins the merchants and sell tables through mid
Join contain ON sell.pid = contain.pid         -- Joins the sell and contain tables through pid
Join place ON contain.oid = place.oid         -- Joins the place and contain tables through oid
Group by merchants.name, year;         -- Groups the output by the company's name and year

-- Query 7

Select merchants.name, SUM(sell.price) AS revenue, year(place.order_date) AS year   -- Calculates annual total sales for each merchant
from merchants
Join sell ON merchants.mid = sell.mid         -- Joins the merchants and sell tables through mid
Join contain ON sell.pid = contain.pid      -- Joins the contain and sell tables through pid
Join place ON contain.oid = place.oid        -- Joins the place and contain tables through oid
Group by merchants.name, year          -- Groups the output by the company's name and year
Order by revenue desc             -- Orders the output in descending order based on revnue
limit 1;         -- Limits the output to the company with the highest sales

-- Query 8

Select shipping_method
from orders
Group by shipping_method
Order by AVG(shipping_cost)    -- Orders the output by average shipping cost
limit 1;       -- Limits the output to the cheapest shipping method

-- Query 9

Select merchants.name, products.category, SUM(sell.price) AS total     -- Calculates the revenue for each category in each company
from merchants
Join sell ON merchants.mid = sell.mid            -- Joins the merchants and sell tables through mid
Join products ON sell.pid = products.pid         -- Joins the products and sell tables through pid
Join contain ON products.pid = contain.pid        -- Joins the contain and products tables through pid
Group by merchants.name, products.category      -- Groups by merchant name and the category of the product
Order by total desc;       -- Orders the output in descending order based on revenue from each category


-- Query 10

Select merchants.name, SUM(sell.price) AS total, customers.fullname    -- Calculates the total spent by each customer for each company
from merchants
Join sell ON merchants.mid = sell.mid        -- Joins the merchants and sell tables through mid
Join contain ON sell.pid = contain.pid       -- Joins the contain and sell tables through pid
Join place ON contain.oid = place.oid        -- Joins the place and contain tables through oid
Join customers ON place.cid = customers.cid      -- Joins the customers and place tables through cid
Group by merchants.name, customers.fullname       -- Groups by merchants and customers name
Order by merchants.name, total desc;       -- Orders the output in descending order based on total spent by each customer








