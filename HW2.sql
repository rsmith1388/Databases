-- Query 1: Average Price of Foods at Each Restaurant 

Select r.name, AVG(f.price) AS average   -- Calculates the average price at each restaurant and selects the restuarant names
from serves s
join restaurants r ON s.restID = r.restID   -- Joins the restaurants and serves tables through restID
join foods f ON s.foodID = f.foodID     -- Joins the serves and foods tables through foodID
group by r.name;     -- Groups the output by restaurant name



-- Query 2: Maximum Food Price at Each Restaurant

Select r.name, max(f.price) AS maximum    -- Calculates the maximum price at each restaurant and selects the restuarant names
from serves s
join restaurants r ON s.restID = r.restID   -- Joins the restaurants and serves tables through restID
join foods f ON s.foodID = f.foodID     -- Joins the serves and foods tables through foodID
group by r.name;       -- Groups the output by restaurant name



-- Query 3: Count of Different Foods Served at Each Restaurant

Select r.name, count(s.foodID) as count    -- Calculates the amount of items at each restaurant and selects the restuarant names
from serves s        
join restaurants r ON s.restID = r.restID    -- Joins the restaurants and serves tables through restID
group by r.name;         -- Groups the output by restaurant name



-- Query 4: Average Price of Food Served by Each Chef

Select w.chefID, AVG(f.price) AS average  -- Calculates the average price of food for each chef and selects the chefIDs
from works w
join serves s ON w.restID = s.restID       -- Joins the works and serves tables through restID
join restaurants r ON s.restID = r.restID    -- Joins the restaurants and serves tables through restID
join foods f ON s.foodID = f.foodID     -- Joins the foods and serves tables through foodID
group by w.chefID;       -- Groups the output by ChefID



-- Query 5: Find the Restaurant with the Highest Average Food Price

Select r.name, AVG(f.price) AS average      -- Calculates the average price at each restaurant and selects the restuarant names
from serves s
join restaurants r ON s.restID = r.restID    -- Joins the restaurants and serves tables through restID
join foods f ON s.foodID = f.foodID     -- Joins the serves and foods tables through foodID
group by r.name        -- Groups the output by restaurant name
limit 1;        -- Limits the output to one restaurant name


