-- Query1
Select s.customer_id, Sum(me.price) 
from
sales s join menu me on s.product_id = me.product_id
group by s.customer_id
order by sum(me.price) ;
    
 -- Query 2
Select customer_id, count(distinct order_date)
from sales
group by customer_id;
    
 -- Query 3
Select t.customer_id, t.product_name   
from (Select row_number() over (partition by customer_id order by order_date) as rownum,
s.customer_id, m.product_name from sales s inner join menu m on s.product_id = m.product_id) t
where t.rownum = 1;
          
 -- Query 4
 Select product_id, count(product_id) from sales group by product_id order by count(product_id);


-- Query 5
Select customer_id, product_id, count(product_id) from sales group by customer_id, product_id order by customer_id;

-- Query 6
Select t.customer_id, t.product_id
from 
(Select row_number() over (partition by s.customer_id) as rownum, s.customer_id,
          s.product_id from sales s join member m on s.customer_id = m.customer_id where s.order_date > m.join_date) t
     where t.rownum = 1;
     
-- Query 7
Select t.customer_id, t.product_id
    from 
    (Select row_number() over (partition by s.customer_id order by s.order_date desc) as rownum, s.customer_id,
          s.product_id from sales s join member m on s.customer_id = m.customer_id where s.order_date < m.join_date) t
    where rownum = 1;

-- Query 8
Select s.customer_id, count(s.product_id), sum(m.price)
    from sales s join menu m on s.product_id = m.product_id
    join member mem on s.customer_id = mem.customer_id
    where s.order_date < mem.join_date
    group by s.customer_id;
    
-- Query 9
Select s.customer_id, sum(20 * m.price)
    from sales s join menu m on s.product_id = m.product_id
    where m.product_name = 'sushi'
    group by s.customer_id;

-- Query 10
Select s.customer_id, sum(20 * m.price)
    from sales s join menu m on s.product_id = m.product_id
    join member mem on s.customer_id = mem.customer_id
    where s.order_date >= mem.join_date and  s.order_date < (mem.join_date + 7)
    group by s.customer_id;
    
-- Bonus question 1
Select s.customer_id, s.order_date, m.product_name, m.price, 
    case 
    when s.customer_id = mem.customer_id then 
    case when s.order_date < mem.join_date then 'N' else 'Y' end
    when s.customer_id != mem.customer_id then 'N'
    else 'N'
    end as is_member
    from
    sales s  full join member mem on s.customer_id = mem.customer_id
    join menu m on s.product_id = m.product_id
    order by s.customer_id, s.order_date, m.product_name;
    
-- Bonus Question 2
Select s.customer_id, s.order_date, m.product_name, m.price, 
    case 
    when s.customer_id = mem.customer_id then
    case when s.order_date < mem.join_date then 'N' else 'Y' end
    when s.customer_id != mem.customer_id then 'N'
    else 'N'
    end as is_member, 
    case when s.order_date >= mem.join_date then rank() over (partition by s.customer_id order by s.order_date) else 0
    end as ranking
    from 
    sales s full join member mem on s.customer_id = mem.customer_id
    join menu m on s.product_id = m.product_id
    order by s.customer_id, s.order_date, m.product_name ;
