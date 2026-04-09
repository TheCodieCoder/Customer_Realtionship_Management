CREATE DATABASE CRM;
USE CRM;
-- TABLE CREATION

CREATE TABLE Address (
	addressId INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postalCode VARCHAR(30) NOT NULL
);

CREATE TABLE Customer (
	customerId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
	addressId INT NOT NULL,
    FOREIGN KEY(addressId) REFERENCES Address(addressId)
);

CREATE TABLE Category (
	categoryId INT PRIMARY KEY AUTO_INCREMENT,
    categoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Brand (
	brandId INT PRIMARY KEY AUTO_INCREMENT,
    brandName VARCHAR(100) NOT NULL
);
 
CREATE TABLE Product (
	productId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    categoryId INT,
    FOREIGN KEY(categoryId) REFERENCES Category(categoryId),
    brandId INT,
    FOREIGN KEY(brandId) REFERENCES Brand(brandId),
    quantity_in_stock INT NOT NULL
);

CREATE TABLE Orders (
	orderId INT PRIMARY KEY AUTO_INCREMENT,
    customerId INT NOT NULL,
    FOREIGN KEY(customerId) REFERENCES Customer(customerId),
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(8,2) NOT NULL,
    OrderStatus ENUM(
		'pending',
		'confirmed',
		'processing',
		'shipped',
		'delivered',
		'cancelled',
		'returned'
    ) NOT NULL,
    PaymentMethod ENUM(
		'cod',
		'upi',
		'card',
		'net_banking',
		'wallet'
	) NOT NULL,
	ShippingAddress VARCHAR(255) NOT NULL
);

CREATE TABLE OrderDetail (
	orderDetailId INT PRIMARY KEY AUTO_INCREMENT,
	orderId INT NOT NULL,
	FOREIGN KEY(orderId) REFERENCES Orders(orderId),
	productId INT NOT NULL,
	FOREIGN KEY(productId) REFERENCES Product(productId),
	Quantity INT NOT NULL,
	UnitPrice DECIMAL(10,2) NOT NULL,
	subtotal DECIMAL(10,2) NOT NULL,
	DiscountApplied DECIMAL(10,2) NOT NULL
);

CREATE TABLE Departments (
	departmentId INT PRIMARY KEY AUTO_INCREMENT,
	DepartmentName VARCHAR(100) NOT NULL
)	AUTO_INCREMENT = 1;

CREATE TABLE Employee (
	employeeId INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	phone VARCHAR(15) NOT NULL UNIQUE,
    addressId INT NOT NULL,
    FOREIGN KEY(addressId) REFERENCES Address(addressId),
	JobTitle VARCHAR(100) NOT NULL,
	departmentId INT NOT NULL,
	FOREIGN KEY(departmentId) REFERENCES Departments(departmentId),
	HireDate DATE NOT NULL
);

CREATE TABLE Lead_ (
    leadId INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL,
    email VARCHAR(200),
    phone VARCHAR(20),

    source VARCHAR(100),

    status ENUM(
        'new',
        'contacted',
        'qualified',
        'lost'
    ) DEFAULT 'new',

    assigned_to INT,
    customerId INT,

    FOREIGN KEY (assigned_to) REFERENCES Employee(employeeId),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);

CREATE TABLE Deal (
    dealId INT AUTO_INCREMENT PRIMARY KEY,

    title VARCHAR(255),
    
    leadId INT,
    customerId INT,

    owner_id INT, -- salesperson

    value DECIMAL(12,2) NOT NULL,

    stage ENUM(
        'prospecting',
        'qualified',
        'proposal',
        'negotiation',
        'won',
        'lost'
    ) NOT NULL,

    expected_close_date DATE,

    FOREIGN KEY (leadId) REFERENCES Lead_(leadId),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId),
    FOREIGN KEY (owner_id) REFERENCES Employee(employeeId)
);

CREATE TABLE Activity (
	activityId INT PRIMARY KEY AUTO_INCREMENT,
	activity_type ENUM(
		'call',
		'email',
		'meeting',
		'note',
		'task',
		'follow_up',
		'status_change',
		'payment',
		'order_update'
	),
    activity_description TEXT,
    ActivityDate DATE NOT NULL,
    ActivityTime TIME NOT NULL,
    location VARCHAR(100) NOT NULL,
    duration TIME NOT NULL,
    customerId INT,
	FOREIGN KEY(customerId) REFERENCES Customer(customerId),
	orderId INT,
	FOREIGN KEY(orderId) REFERENCES Orders(orderId),
    leadId INT,
    FOREIGN KEY(leadId) REFERENCES Lead_(leadId),
    dealId INT,
    FOREIGN KEY(dealId) REFERENCES Deal(dealId)
);

CREATE TABLE ActivityEmployees (		-- Junction Table
	activityId INT,
    employeeId INT,
    PRIMARY KEY(activityId, employeeId),
    FOREIGN KEY(activityId) REFERENCES Activity(activityId),
    FOREIGN KEY(employeeId) REFERENCES Employee(employeeId)
);


-- INDEXING TABLES --

CREATE INDEX idx_Address ON Address(addressId);
CREATE INDEX idx_Customer ON Customer(customerId);
CREATE INDEX idx_Category ON Category(categoryId);
CREATE INDEX idx_Brand ON Brand(brandId);
CREATE INDEX idx_Product ON Product(productId);
CREATE INDEX idx_Orders ON Orders(orderId);
CREATE INDEX idx_OrderDetail ON OrderDetail(orderDetailId);
CREATE INDEX idx_Departments ON Departments(departmentId);
CREATE INDEX idx_Employee ON Employee(employeeId);
CREATE INDEX idx_Activity ON Activity(activityId);
CREATE INDEX idx_Lead ON Lead_(leadId);
CREATE INDEX idx_deal ON Deal(dealId);

-- VIEWING TABLE
SELECT * FROM Address;
SELECT * FROM Customer;
SELECT * FROM Category;
SELECT * FROM Brand;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM OrderDetail;
SELECT * FROM Departments;
SELECT * FROM Employee;
SELECT * FROM Lead_;
SELECT * FROM Deal;
SELECT * FROM Activity;
SELECT * FROM ActivityEmployees;
