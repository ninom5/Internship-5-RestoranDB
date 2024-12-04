INSERT INTO City(cityid, name) VALUES(501, 'Split');

INSERT INTO Deliverer(PersonnelId)
	SELECT PersonnelId FROM Personnel
	WHERE Type = 'deliverer';