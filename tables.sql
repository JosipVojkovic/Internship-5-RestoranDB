CREATE TABLE Restaurants(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	Capacity INT NOT NULL CHECK(Capacity > 0),
	WorkingTime VARCHAR(30)
)

CREATE TABLE Dishes(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Category VARCHAR(30) NOT NULL CHECK(Category IN ('Predjelo', 'Glavno jelo', 'Desert')),
	Calories INT NOT NULL CHECK(Calories > 0)
)

CREATE TABLE RestaurantDishes(
	Id SERIAL PRIMARY KEY,
	RestaurantId INT REFERENCES Restaurants(Id),
	DishId INT REFERENCES Dishes(Id),
	Price DECIMAL NOT NULL CHECK(Price > 0),
	Availability BOOLEAN NOT NULL
)

CREATE TABLE Users(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	OrdersNum INT DEFAULT 0 CHECK(OrdersNum >= 0),
	Spenditure DECIMAL DEFAULT 0.00 CHECK(Spenditure >= 0),
	Loyalty BOOLEAN GENERATED ALWAYS AS (OrdersNum > 15 AND Spenditure > 1000) STORED
)

CREATE TABLE Workers(
	Id SERIAL PRIMARY KEY,
	Role VARCHAR(30) NOT NULL CHECK(Role IN ('Kuhar', 'Dostavljac', 'Konobar')),
	Age INT NOT NULL CHECK (Role != 'Kuhar' OR Age >= 18),
	DrivingLicence BOOLEAN NOT NULL CHECK(Role != 'Dostavljac' OR (DrivingLicence = TRUE AND Age >= 18)),
	RestaurantId INT REFERENCES Restaurants(Id)
)

CREATE TABLE Deliverers(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	DeliveriesNum INT DEFAULT 0,
	WorkerId INT UNIQUE REFERENCES Workers(Id)
)

CREATE TABLE Orders(
	Id SERIAL PRIMARY KEY,
	Address VARCHAR(30) NOT NULL,
	Amount DECIMAL NOT NULL,
	Date Date NOT NULL DEFAULT CURRENT_DATE,
	OrderType VARCHAR(30) NOT NULL CHECK(OrderType IN ('Za van', 'U restoranu')),
	RestaurantId INT REFERENCES Restaurants(Id),
	UserId INT REFERENCES Users(Id),
	DelivererId INT REFERENCES Deliverers(Id),
	Note VARCHAR(70)
)

CREATE TABLE OrderDishes(
	Id SERIAL PRIMARY KEY,
	OrderId INT REFERENCES Orders(Id),
	DishId INT REFERENCES Dishes(Id),
	Amount INT NOT NULL CHECK(Amount > 0)
)

CREATE TABLE Rating(
	Id SERIAL PRIMARY KEY,
	RatingNum INT NOT NULL CHECK(RatingNum >= 1 AND RatingNum <= 5),
	Comment VARCHAR(100),
	DishId INT REFERENCES Dishes(Id)
)



