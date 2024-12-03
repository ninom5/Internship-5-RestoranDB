CREATE TABLE City(
	CityId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
);

CREATE TABLE Restaurant(
    RestaurantId SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
	CityId INT,
    FOREIGN KEY (CityId) REFERENCES City(CityId),
    NumberOfTables INT CHECK (NumberOfTables > 0),
    OpeningTime TIME NOT NULL,
    ClosingTime TIME NOT NULL
);

CREATE TABLE Meal(
    MealId SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(70),
    Category VARCHAR(30) CHECK (Category IN ('predjelo', 'glavno jelo', 'desert')),
    Calories FLOAT CHECK (Calories > 0),
    Price FLOAT CHECK (Price > 0)
);

CREATE TABLE Menu(
	MenuId SERIAL PRIMARY KEY,
	RestaurantId INT,
	MealId INT,
    FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId),
    FOREIGN KEY (MealId) REFERENCES Meal(MealId),
    Availability BOOLEAN NOT NULL
);

CREATE TABLE Guest(
	GuestId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Birth TIMESTAMP		
);

CREATE TABLE LoyltyCard(
	CardId SERIAL PRIMARY KEY,
	GuestId INT,
    FOREIGN KEY (GuestId) REFERENCES Guest(GuestId),
    TotalOrders INT DEFAULT 0,
    TotalSpent FLOAT DEFAULT 0.0,
    Eligible BOOLEAN GENERATED ALWAYS AS (TotalOrders > 15 AND TotalSpent > 1000.0) STORED
);

CREATE TABLE Personnel(
	PersonnelId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Type VARCHAR(30) CHECK(Type IN ('cook', 'deliverer', 'waiter')),
	Birth TIMESTAMP,
	DriverLicence BOOLEAN,
	RestaurantId INT,
	FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId)
);

ALTER TABLE Personnel
	ADD CONSTRAINT CheckKuhar CHECK (Type = 'cook' AND DATE_PART('year', NOW()) - DATE_PART('year', Birth) >= 18),
    ADD CONSTRAINT CheckDostavljac CHECK (Type = 'deliverer' AND DriverLicence = TRUE);

			
CREATE TABLE Delivery(
	DeliveryId SERIAL PRIMARY KEY,
	DeliveryAdress VARCHAR(100) NOT NULL,
	DeliveryTime TIMESTAMP,
	DelivererId INT,
	FOREIGN KEY (DelivererId) REFERENCES Personnel(PersonnelId)
);

CREATE TABLE OnSite(
	OnSiteId SERIAL PRIMARY KEY,
	WaiterId INT,
	FOREIGN KEY (WaiterId) REFERENCES Personnel(PersonnelId)
);

CREATE TABLE "Order"(
	OrderId SERIAL PRIMARY KEY,
	Price FLOAT,
	OrderType VARCHAR(10) CHECK (OrderType IN ('delivery', 'onsite')),
	Note VARCHAR(150),
	GuestId INT,
	DeliveryId INT,
	OnSiteId INT,
	FOREIGN KEY (GuestId) REFERENCES Guest(GuestId),
	FOREIGN KEY (DeliveryId) REFERENCES Delivery(DeliveryId),
	FOREIGN KEY (OnSiteId) REFERENCES OnSite(OnSiteId)
);

CREATE TABLE OrderMeal (
    OrderMealId SERIAL PRIMARY KEY,
	OrderId INT,
	MealId INT,
    FOREIGN KEY (OrderId) REFERENCES "Order"(OrderId),
    FOREIGN KEY (MealId) REFERENCES Meal(MealId),
    Quantity INT NOT NULL CHECK (Quantity > 0)
);

CREATE TABLE Review(
	ReviewId SERIAL PRIMARY KEY,
	GradeDelivery INT CHECK(GradeDelivery BETWEEN 1 AND 5),
	GradeMeal INT CHECK(GradeMeal BETWEEN 1 AND 5),
	UserComment VARCHAR(100),
	OrderId INT,
	FOREIGN KEY (OrderId) REFERENCES "Order"(OrderId)
);