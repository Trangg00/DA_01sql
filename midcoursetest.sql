/* b1. tao danh sach tat ca chi phi thay the khac nhau cua cac film
      chi phi thay the thap nhat ? */

select distinct (replacement_cost)
from film
order by replacement_cost

/* b2. cung cap cai nhin tong quan ve so luong phim co chi phi thay the trong cac pham vi:
1. low: 9.99 - 19.99
2. medium: 20.00 - 24.99
3. high: 25.00 - 29.00
co bao nhieu phim co chi phi thay the thuoc nhom low? */
  
select count(*),
case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end pham_vi
from film
group by case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end 

/* b3. tao danh sach cac film_title duoc sap xep theo do dai giam dan. loc ket qua cac phim trong danh muc 'drama' hoac 'sports.
phim dai nhat thuoc the loai nao, dai bao nhieu? */

select film.title, film.length, category.name
from film inner join film_category on film.film_id=film_category.film_id
inner join category on film_category.category_id=category.category_id
where category.name in ('Drama','Sports')
order by film.length desc

/* b4. dua ra cai nhin tong quan ve so luong phim (title) trong moi danh muc (category).
the loai danh muc nao la pho bien nhat? */

select category.name, count(film.title)
from film join film_category on film.film_id=film_category. film_id
join category on film_category.category_id=category.category_id
group by category.name
order by count(film.title) desc

/* b5. dua ra cai nhin tong quan ve ho va ten cua cac dien vien cung nhu so luong phim ho tham gia.
dien vien dong nhieu phim nhat? */

select actor.first_name, actor.last_name, count(film_actor.film_id) as count_movie
from actor join film_actor on actor.actor_id=film_actor.actor_id
group by actor.first_name, actor.last_name
order by count(film_actor.film_id) desc

/* b6. tim cac dia chi khong lien quan den bat ky khach hang nao.
co bao nhieu dia chi nhu vay? */

select count(address.address)
from address left join customer on address.address_id=customer.address_id
where customer.first_name is null

/* b7. danh sach cac thanh pho va doanh thu tuong ung.
thanh pho nao dat doanh thu cao nhat? */

select city.city, sum(payment.amount)
from city join address on city.city_id=address.city_id
join customer on address.address_id=customer.address_id
join payment on customer.customer_id=payment.customer_id
group by city.city
order by sum(payment.amount) desc

/* b8. tao danh sach tra ra 2 cot du lieu:
cot 1: thong tin thanh pho vaf dat nuoc
cot 2: doanh thu tuong ung
thanh pho nao dat doanh thu cao nhat? */

select city.city, country.country, sum(payment.amount)
from country join city on city.country_id=country.country_id
join address on city.city_id=address.city_id
join customer on address.address_id=customer.address_id
join payment on customer.customer_id=payment.customer_id
group by city.city, country.country
order by sum(payment.amount) desc





















