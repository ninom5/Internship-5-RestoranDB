CREATE TABLE City(
    CityId SERIAL PRIMARY KEY,
    Name VARCHAR(30) NOT NULL
);

CREATE TABLE Restaurant(
    RestaurantId SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    CityId INT NOT NULL,
    NumberOfTables INT CHECK (NumberOfTables > 0),
    OpeningTime TIME NOT NULL,
    ClosingTime TIME NOT NULL,
	HasDelivery BOOLEAN,
    FOREIGN KEY (CityId) REFERENCES City(CityId)
);

CREATE TABLE Meal(
    MealId SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Category VARCHAR(30) CHECK (Category IN ('predjelo', 'glavno jelo', 'desert')),
    Calories FLOAT CHECK (Calories > 0),
    Price FLOAT CHECK (Price > 0)
);

CREATE TABLE MenuItems(
    MenuItemsId SERIAL PRIMARY KEY,
    RestaurantId INT NOT NULL,
    MealId INT NOT NULL,
    Availability BOOLEAN NOT NULL,
    FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId),
    FOREIGN KEY (MealId) REFERENCES Meal(MealId)
);
ALTER TABLE MenuItems
    ADD CONSTRAINT UniqueRestaurantMeal UNIQUE (RestaurantId, MealId);

CREATE TABLE Guest(
    GuestId SERIAL PRIMARY KEY,
    Name VARCHAR(30) NOT NULL,
    Surname VARCHAR(50),
    Birth DATE CHECK (Birth <= CURRENT_DATE)
);

CREATE TABLE "Order"(
    OrderId SERIAL PRIMARY KEY,
    Price FLOAT NOT NULL CHECK (Price > 0),
    OrderType VARCHAR(10) CHECK (OrderType IN ('delivery', 'onsite')) NOT NULL,
    Note VARCHAR(150),
    GuestId INT NOT NULL,
    Date TIMESTAMP,
    FOREIGN KEY (GuestId) REFERENCES Guest(GuestId)
);
ALTER TABLE "Order"
    ADD COLUMN RestaurantId INT;
ALTER TABLE "Order"
    ADD CONSTRAINT restaurantid_fk FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId);

CREATE TABLE LoyaltyCard(
    CardId SERIAL PRIMARY KEY,
    GuestId INT NOT NULL,
    TotalOrders INT DEFAULT 0,
    TotalSpent FLOAT DEFAULT 0.0,
    Eligible BOOLEAN,
    FOREIGN KEY (GuestId) REFERENCES Guest(GuestId)
);

CREATE TABLE Personnel(
    PersonnelId SERIAL PRIMARY KEY,
    Name VARCHAR(30) NOT NULL,
    Surname VARCHAR(50),
    Type VARCHAR(30) CHECK (Type IN ('cook', 'deliverer', 'waiter')) NOT NULL,
    Birth DATE NOT NULL,
    DriverLicence BOOLEAN,
    RestaurantId INT NOT NULL,
    FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId)
);
ALTER TABLE Personnel
ADD CONSTRAINT CheckDriverAndAge CHECK (
    (Type = 'deliverer' AND DriverLicence = TRUE) OR
    (Type = 'cook' AND DATE_PART('year', AGE(Birth)) >= 18) OR
    (Type = 'waiter')
);
ALTER TABLE Personnel
	ADD CONSTRAINT UniquePersonnelRestaurant UNIQUE (PersonnelId, RestaurantId);

CREATE TABLE Deliverer (
    DelivererId SERIAL PRIMARY KEY,
    PersonnelId INT NOT NULL,
    FOREIGN KEY (PersonnelId) REFERENCES Personnel(PersonnelId)
);

CREATE TABLE Waiter (
    WaiterId SERIAL PRIMARY KEY,
    PersonnelId INT NOT NULL,
    FOREIGN KEY (PersonnelId) REFERENCES Personnel(PersonnelId)
);

CREATE TABLE Delivery(
    DeliveryId SERIAL PRIMARY KEY,
    DeliveryAddress VARCHAR(100) NOT NULL,
    DeliveryTime TIMESTAMP NOT NULL,
    DelivererId INT NOT NULL,
    OrderId INT NOT NULL,
    FOREIGN KEY (DelivererId) REFERENCES Deliverer(DelivererId),
    FOREIGN KEY (OrderId) REFERENCES "Order"(OrderId)
);

CREATE TABLE OnSite(
    OnSiteId SERIAL PRIMARY KEY,
    OrderId INT NOT NULL,
    WaiterId INT NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES "Order"(OrderId),
    FOREIGN KEY (WaiterId) REFERENCES Waiter(WaiterId)
);


CREATE TABLE OrderMeal (
    OrderMealId SERIAL PRIMARY KEY,
    OrderId INT NOT NULL,
    MealId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (OrderId) REFERENCES "Order"(OrderId),
    FOREIGN KEY (MealId) REFERENCES Meal(MealId)
);

CREATE TABLE Review(
    ReviewId SERIAL PRIMARY KEY,
    GradeDelivery INT CHECK (GradeDelivery BETWEEN 1 AND 5),
    GradeMeal INT CHECK (GradeMeal BETWEEN 1 AND 5),
    UserComment VARCHAR(100),
    OrderId INT NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES "Order"(OrderId)
);
ALTER TABLE Review
	ADD COLUMN RestaurantId INT,
	ADD FOREIGN KEY (RestaurantId) REFERENCES Restaurant(RestaurantId);
