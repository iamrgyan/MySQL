# Q1. How many units of cars sold in 2022?
select Sales_Year, sum(sales_unit) as Unit_Sold from sales_2022 where sales_year = "2022";

# Q2. Get the sales month wise and arrange in a descending order
select Sales_Month, sum(sales_unit) as Unit_Sold from sales_2022 group by Sales_Month order by Unit_Sold desc;

# Q3. Get the sales OEM wise and arrange in a descending order
select OEM, sum(sales_unit) as Unit_Sold from sales_2022 group by OEM order by Unit_Sold desc;

# Q4. Get the sales Model wise and arrange in a descending order
select Model, sum(sales_unit) as Unit_Sold from sales_2022 group by Model order by Unit_Sold desc;

# Q5. How much value for cars sold in year 2022. Keep base price as a stadard price for the results.
alter table carprice_2022 add primary key (Model);
alter table sales_2022 add foreign key (Model) references carprice_2022(Model);
/*
Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails
(`carsales_india`.`#sql-1690_14`, CONSTRAINT `sales_2022_ibfk_1` FOREIGN KEY (`Model`) 
REFERENCES `carprice_2022` (`Model`)
*/
select distinct(model) from sales_2022;
select distinct(model) from carprice_2022;

insert into carprice_2022 values ("Carnival", 3097000, 3548000);
update sales_2022 set model = "Redi Go" where model = "Redi-Go";
update carprice_2022 set model = "Scorpio C&N" where model = "Scorpio";
update sales_2022 set model = "Thar" where model = "Thar 4X4";
update carprice_2022 set model = "Alturas" where model = "Alturus";
update carprice_2022 set model = "Vellfire" where model = "Velllfire";

alter table sales_2022 add foreign key (Model) references carprice_2022(Model);

desc carprice_2022;
desc sales_2022;

select s.Sales_Year, sum(s.Sales_Unit*c.Base_Price) as Value_Sold_INR 
from sales_2022 s
join carprice_2022 c on c.Model = s.Model;
use carsales_india;

# Q6. Get the sales in month wise in INR and arrange in a descending order
select s.Sales_Month, sum(s.Sales_Unit*c.Base_Price) as Value_Sold_INR 
from sales_2022 s
join carprice_2022 c on c.Model = s.Model group by s.sales_month order by Value_Sold_INR desc;

# Q7. Get the sales OEM wise in INR and arrange in a descending order
select s.OEM, sum(s.sales_unit*c.base_price) as Value_Sold_INR
from sales_2022 s
join carprice_2022 c on c.model = s.model group by s.OEM order by Value_Sold_INR desc;

# Q8. Get the sales Model wise in INR and arrange in a descending order
select s.Model, sum(s.Sales_Unit*c.Base_Price) as Value_Sold_INR
from sales_2022 s
join carprice_2022 c on c.model = s.model group by s.model order by Value_Sold_INR desc;

# Q9. Find out the number of OEM available in dataset
select count(distinct(OEM)) as Total_OEM_Count from sales_2022;

# Q10. Find out the number of car Models in dataset
select count(distinct(model)) as Total_Model_Count from sales_2022;

# Q11. Get the list of car models OEM wise.
select distinct(OEM), model from sales_2022;

# Q12. Get the details of number of car models OEM Wise
select distinct(OEM), count(distinct(model)) as Product_Line from sales_2022 group by OEM order by Product_Line desc;

# Q13. Get OEM Details country wise, parent company, Origin country, parent coutnry company
select * from general_info;

# Q14. Get count of OEM Origin country wise
select Origin_Country, count(OEM) as OEM  from general_info group by origin_country order by OEM desc;

# Q15. Get the list of OEM's as per their presence in indian market in year, arrange in descending year.
select OEM, Started_in_India, (2022-started_in_india) as Years_in_India, founded_in_year from general_info order by years_in_india desc;

# Q16. Arrange the OEM in order to Oldest to youngest in terms of year, and year of business till year 2022 of foundation
select OEM, Founded_in_Year, year(date_add('0001-01-01', interval 2021 year))-founded_in_year as Business_Years 
from general_info order by founded_in_year asc;

# Q17. delete tax table tax_2022 and create a new table "vehicle_tax" with as per existing vehicle datas.
drop table vehicle_tax;
create table Vehicle_Tax
(Tax_Name varchar(50), Fuel_Type varchar(50), CC_Condition varchar(50), Engine_CC int, Length_Condition varchar(50), Vehicle_Length_mm int,
GC_Condition varchar(50), Ground_Clearance int, GST int, Compensation_Cess int, Total_Tax_Percent int);

insert into vehicle_tax
values
("Petrol_29", "Petrol", "Less_than", 1200, "Less_than", 4000, null, null, 28, 1, 29),
("CNG_29", "CNG", "Less_than", 1200, "Less_than", 4000, null, null, 28, 1, 29),
("Diesel_31", "Diesel", "Less_than", 1500, "Less_than", 4000, null, null, 28, 3, 31),
("Petrol_43", "Petrol", "Less_than", 1200, "Greater_than", 4000, null, null, 28, 15, 43),
("CNG_43", "CNG", "Less_than", 1200, "Greater_than", 4000, null, null, 28, 15, 43),
("Diesel_48", "Diesel", "Less_than", 1500, "Greater_than", 4000, null, null, 28, 20, 48),
("Petrol_50", "Petrol", "Greater_than", 1200, "Greater_than", 0, null, null, 28, 22, 50),
("CNG_50", "CNG", "Greater_than", 1200, "Greater_than", 0, null, null, 28, 22, 50),
("Diesel_50", "Diesel", "Greater_than", 1500, "Greater_than", 4000, "Greater_than", 169, 28, 22, 50);
select * from vehicle_tax;
drop table tax_2022;
show tables;

# Q18. Find the detailed list of vehicles as per the tax slabs
alter table vehicle_details add primary key(Model_Name);
alter table vehicle_engine add foreign key(model) references vehicle_details(model_name);
desc vehicle_details;
desc vehicle_engine;

-- Tax Slab 29% - Petrol
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "Petrol" and e.Engine_CC < 1200 and d.Length_mm < 4000;

-- Tax Slab 29% CNG
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "CNG" and e.Engine_CC < 1200 and d.Length_mm < 4000;

-- Tax Slab 31% Diesel
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "Diesel" and e.Engine_CC < 1500 and d.Length_mm < 4000;

-- Tax Slab 43% Petrol
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "Petrol" and e.Engine_CC < 1200 and d.Length_mm > 4000;

-- Tax Slab 43% CNG
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "CNG" and e.Engine_CC < 1200 and d.Length_mm > 4000;

-- Tax Slab 48% Diesel
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "Diesel" and e.Engine_CC < 1500 and d.Length_mm > 4000;

-- Tax Slab 50% Petrol
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "Petrol" and e.Engine_CC > 1200;

-- Tax Slab 50% CNG
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "CNG" and e.Engine_CC > 1200;

-- Tax Slab 50% Diesel
select d.OEM, d.Model_Name, E.Fuel_Type, E.Engine_CC, d.Length_MM
from Vehicle_Details d
join Vehicle_Engine e on d.Model_Name = e.Model
where e.Fuel_Type = "Diesel" and e.Engine_CC > 1500 and d.Length_MM > 4000 and Ground_Clearance_MM >=170;

# Q19. Find out the sales unit and sales value as per the body type
select d.Body_Type, sum(s.Sales_Unit) as Sale_Unit, sum(s.sales_unit*c.base_price) as Value_Sold_INR
from Vehicle_Details d
join Sales_2022 s
on d.model_name = s.model join carprice_2022 c on d.model_name = c.model group by d.body_type order by Value_Sold_INR desc;

# Q20. Find out the sales unit and sales value as per the sub body type
select d.subbody_Type, sum(s.Sales_Unit) as Sale_Unit, sum(s.sales_unit*c.base_price) as Value_Sold_INR
from Vehicle_Details d
join Sales_2022 s
on d.model_name = s.model join carprice_2022 c on d.model_name = c.model group by d.subbody_type order by Value_Sold_INR desc;

# Q21. Find out the sales unit and sales value as per the seating capacity
select d.Seating_Capacity, sum(s.Sales_Unit) as Sale_Unit, sum(s.sales_unit*c.base_price) as Value_Sold_INR
from Vehicle_Details d
join Sales_2022 s
on d.model_name = s.model join carprice_2022 c on d.model_name = c.model group by d.seating_capacity order by Value_Sold_INR desc;

# Q22. Find out the sales unit and sales value as per the segment
select d.Segment, sum(s.Sales_Unit) as Sale_Unit, sum(s.sales_unit*c.base_price) as Value_Sold_INR
from Vehicle_Details d
join Sales_2022 s
on d.model_name = s.model join carprice_2022 c on d.model_name = c.model group by d.segment order by Value_Sold_INR desc;
use carsales_india;















