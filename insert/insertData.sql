INSERT INTO City(cityid, name) VALUES(501, 'Split');

INSERT INTO Deliverer(PersonnelId)
	SELECT PersonnelId FROM Personnel
	WHERE Type = 'deliverer';


INSERT INTO Waiter(PersonnelId) SELECT PersonnelId
	FROM Personnel WHERE Type = 'waiter';

INSERT INTO LoyltyCard (GuestId, TotalOrders, TotalSpent, Eligible)
SELECT DISTINCT o.GuestId, 0, 0, FALSE
FROM "Order" o;

UPDATE LoyltyCard Loylty
SET 
    TotalOrders = subquery.TotalOrders,
    TotalSpent = subquery.TotalSpent
FROM (
    SELECT 
        o.GuestId, 
        COUNT(o.OrderId) AS TotalOrders, 
        SUM(o.Price) AS TotalSpent
    FROM "Order" o
    GROUP BY o.GuestId
) AS subquery
WHERE lc.GuestId = subquery.GuestId;