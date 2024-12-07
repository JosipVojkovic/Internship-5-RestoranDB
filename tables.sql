CREATE TABLE Restaurants(
	RestaurantId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	Capacity INT,
	WorkingTime VARCHAR(30)
)

CREATE TABLE Menus(
	MenuId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	Capacity INT,
	WorkingTime VARCHAR(30)
)