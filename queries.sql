-- 1. Ispis svih jela koja imaju cijenu manju od 15 eura.
SELECT d.Name, d.Category, d.Calories, rd.Price FROM RestaurantDishes rd
JOIN Dishes d ON d.Id = rd.DishId 
WHERE rd.Price < 15

-- 2. Ispis svih narudžbi iz 2023. godine koje imaju ukupnu vrijednost veću od 50 eura.
SELECT * FROM Orders o
WHERE DATE_PART('year', o.Date) = 2023 AND o.Amount > 50

-- 3. Ispis svih dostavljača s više od 100 uspješno izvršenih dostava do danas.
SELECT * FROM Deliverers d
WHERE d.DeliveriesNum > 100

-- 4. Ispis svih kuhara koji rade u restoranima u Zagrebu.
SELECT w.Role, w.Age, r.Name AS Restaurant, r.City FROM Workers w
JOIN Restaurants r ON r.Id = w.RestaurantId
WHERE w.Role = 'Kuhar' AND r.City = 'Zagreb'

-- 5. Ispis broja narudžbi za svaki restoran u Splitu tijekom 2023. godine.
SELECT RestaurantId,
	(SELECT COUNT(*) 
	FROM Orders o 
	WHERE o.RestaurantId = Orders.RestaurantId AND DATE_PART('year', o.Date) = 2023) AS TotalOrders 
FROM Orders

-- 6. Ispis svih jela u kategoriji "Deserti" koja su naručena više od 10 puta u prosincu 2023.
SELECT DISTINCT d.Name AS DishName
FROM Dishes d
JOIN OrderDishes od ON d.Id = od.DishId
JOIN Orders o ON od.OrderId = o.Id
WHERE 
    d.Category = 'Desert'
    AND o.Date BETWEEN '2023-12-01' AND '2023-12-31'
    AND (
        SELECT COUNT(*)
        FROM OrderDishes sub_od
        JOIN Orders sub_o ON sub_od.OrderId = sub_o.Id
        WHERE 
            sub_od.DishId = d.Id
            AND sub_o.Date BETWEEN '2023-12-01' AND '2023-12-31'
    ) > 10
	
-- 7. Ispis broja narudžbi korisnika s prezimenom koje počinje na "M".
SELECT u.Name, u.Surname, 
       (SELECT COUNT(*) 
        FROM Orders o 
        WHERE o.UserId = u.Id) AS OrderCount
FROM Users u
WHERE u.Surname LIKE 'M%';

-- 8. Ispis prosječne ocjene za restorane u Rijeci.
SELECT r.Name AS RestaurantName,
       (SELECT AVG(rt.RatingNum)
        FROM Rating rt
        JOIN Dishes d ON rt.DishId = d.Id
        JOIN RestaurantDishes rd ON d.Id = rd.DishId
        WHERE rd.RestaurantId = r.Id) AS AverageRating
FROM Restaurants r
WHERE r.City = 'Rijeka';

-- 9. Ispis svih restorana koji imaju kapacitet veći od 30 stolova i nude dostavu.
SELECT DISTINCT r.Name
FROM Restaurants r
JOIN Orders o ON r.Id = o.RestaurantId
WHERE r.Capacity > 30
  AND o.OrderType = 'Za van';
  
-- 10. Uklonite iz jelovnika jela koja nisu naručena u posljednje 2 godine.
DELETE FROM RestaurantDishes
WHERE DishId NOT IN (
    SELECT DISTINCT od.DishId
    FROM OrderDishes od
    JOIN Orders o ON od.OrderId = o.Id
    WHERE o.Date >= CURRENT_DATE - INTERVAL '2 years'
)

-- 11. Izbrišite loyalty kartice svih korisnika koji nisu naručili nijedno jelo u posljednjih godinu dana.
UPDATE Users
SET OrdersNum = 0, Spenditure = 0.00
WHERE Id NOT IN (
    SELECT DISTINCT u.Id
    FROM Users u
    JOIN Orders o ON u.Id = o.UserId
    JOIN OrderDishes od ON o.Id = od.OrderId
    WHERE o.Date >= CURRENT_DATE - INTERVAL '1 year'
)
