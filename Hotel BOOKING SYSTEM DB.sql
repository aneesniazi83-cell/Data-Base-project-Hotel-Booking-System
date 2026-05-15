-- ======================================================
--   HOTEL BOOKING SYSTEM DATABASE (ERD READY SCHEMA)
-- ======================================================

-- Drop existing database (optional, for re-run)


-- Create new database

USE HotelBookingDB;

-- =========================
-- 1. HOTEL TABLE
-- =========================
CREATE TABLE Hotel (
    HotelID INT AUTO_INCREMENT PRIMARY KEY,
    HotelName VARCHAR(100) NOT NULL,
    Location VARCHAR(150) NOT NULL,
    ContactNumber VARCHAR(20),
    Email VARCHAR(100),
    Rating DECIMAL(2,1) CHECK (Rating BETWEEN 0 AND 5)
);

-- =========================
-- 2. CUSTOMER TABLE
-- =========================
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(255),
    NationalID VARCHAR(50) UNIQUE
);

-- =========================
-- 3. ROOMTYPE TABLE
-- =========================
CREATE TABLE RoomType (
    RoomTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL,
    Description VARCHAR(255),
    PricePerNight DECIMAL(10,2) NOT NULL CHECK (PricePerNight > 0)
);

-- =========================
-- 4. ROOM TABLE
-- =========================
CREATE TABLE Room (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    HotelID INT NOT NULL,
    RoomTypeID INT NOT NULL,
    RoomNumber VARCHAR(10) NOT NULL,
    AvailabilityStatus ENUM('Available','Booked','Maintenance') DEFAULT 'Available',
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (HotelID, RoomNumber)
);

-- =========================
-- 5. STAFF TABLE
-- =========================
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    HotelID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    ContactNumber VARCHAR(20),
    Email VARCHAR(100),
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- 6. BOOKING TABLE
-- =========================
CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumberOfGuests INT DEFAULT 1 CHECK (NumberOfGuests > 0),
    BookingStatus ENUM('Confirmed','CheckedIn','CheckedOut','Cancelled') DEFAULT 'Confirmed',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- 7. PAYMENT TABLE
-- =========================
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT UNIQUE NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod ENUM('Cash','Card','Online') NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentStatus ENUM('Pending','Completed','Refunded') DEFAULT 'Pending',
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- 8. SERVICE TABLE
-- =========================
CREATE TABLE Service (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    ServiceCharge DECIMAL(10,2) NOT NULL CHECK (ServiceCharge >= 0)
);

-- =========================
-- 9. BOOKING_SERVICE TABLE (M-M RELATIONSHIP)
-- =========================
CREATE TABLE Booking_Service (
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT DEFAULT 1 CHECK (Quantity > 0),
    PRIMARY KEY (BookingID, ServiceID),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

USE HotelBookingDB;         -- or your DB name
SHOW CREATE TABLE Customer;
DESCRIBE Customer;


INSERT INTO Hotel (HotelName, Location, ContactNumber, Email, Rating)
VALUES
('Grand Palace Hotel', 'Lahore, Pakistan', '042-111-222333', 'info@grandpalace.com', 4.5),
('Royal Comfort Hotel', 'Karachi, Pakistan', '021-222-333444', 'contact@royalcomfort.com', 4.2);

INSERT INTO RoomType (TypeName, Description, PricePerNight)
VALUES
('Single', 'Single room with basic amenities', 5000),
('Double', 'Double bed room suitable for couples', 8000),
('Deluxe', 'Luxury room with premium features', 12000),
('Suite', 'Exclusive suite with living area & lounge', 20000);

INSERT INTO Room (HotelID, RoomTypeID, RoomNumber, AvailabilityStatus)
VALUES
(1, 1, '101', 'Available'),
(1, 2, '102', 'Booked'),
(1, 3, '201', 'Available'),
(2, 1, '301', 'Maintenance'),
(2, 4, '401', 'Available');


INSERT INTO Customer (FullName, Email, PhoneNumber, Address, NationalID)
VALUES
('Ayesha Khan', 'ayesha.khan@example.com', '03001234567', 'Lahore, Pakistan', NULL),
('David Smith', 'david.smith@example.com', '03019876543', 'Karachi, Pakistan', NULL),
('Sara Malik', 'sara.malik@example.com', '03451239876', 'Islamabad, Pakistan', NULL),
('John Walker', 'john.walker@example.com', '03117894523', 'Rawalpindi, Pakistan', NULL),
('Fatima Raza', 'fatima.raza@example.com', '03334567890', 'Multan, Pakistan', NULL);

INSERT INTO Staff (HotelID, FullName, Role, ContactNumber, Email)
VALUES
(1, 'Imran Ali', 'Manager', '03004561234', 'imran.ali@hotel.com'),
(1, 'Sana Javed', 'Receptionist', '03007894561', 'sana.javed@hotel.com'),
(2, 'Zain Ahmed', 'Manager', '03114567890', 'zain.ahmed@hotel.com'),
(2, 'Maria Khan', 'Housekeeping', '03451236789', 'maria.khan@hotel.com');

INSERT INTO Booking (CustomerID, RoomID, CheckInDate, CheckOutDate, NumberOfGuests, BookingStatus)
VALUES
(1, 1, '2025-01-10', '2025-01-12', 2, 'Confirmed'),
(2, 2, '2025-02-05', '2025-02-07', 1, 'CheckedIn'),
(3, 3, '2025-03-01', '2025-03-03', 3, 'Confirmed'),
(4, 4, '2025-04-10', '2025-04-11', 1, 'Cancelled'),
(5, 5, '2025-05-15', '2025-05-18', 2, 'Confirmed');

INSERT INTO Payment (BookingID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
VALUES
(1, '2025-01-10', 'Card', 10000, 'Completed'),
(2, '2025-02-05', 'Cash', 16000, 'Completed'),
(3, '2025-03-01', 'Card', 24000, 'Completed'),
(4, '2025-04-10', 'Online', 5000, 'Refunded'),
(5, '2025-05-15', 'Card', 60000, 'Completed');

INSERT INTO Service (ServiceName, Description, ServiceCharge)
VALUES
('Breakfast', 'Buffet breakfast', 800),
('Laundry', 'Washing & ironing service', 500),
('Airport Pickup', 'Car pickup from airport', 3000),
('Gym Access', 'Access to fitness center', 1000);

INSERT INTO Booking_Service (BookingID, ServiceID, Quantity)
VALUES
(1, 1, 2),  -- Booking 1 took Breakfast twice
(1, 2, 1),  -- Booking 1 took Laundry once
(2, 3, 1),  -- Booking 2 used Airport Pickup
(3, 4, 3),  -- Booking 3 used Gym access 3 times
(5, 1, 2);  -- Booking 5 took Breakfast twice

SHOW TABLES;
SELECT * FROM Customer;