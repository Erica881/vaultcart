-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS vaultcart;
USE vaultcart;

-- 1. Membership Table
CREATE TABLE IF NOT EXISTS Membership_Sellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    CardNumber VARCHAR(255) NOT NULL,
    passwordHash VARCHAR(512) NOT NULL,
    PasswordSalt VARCHAR(512) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Sessions Table
CREATE TABLE IF NOT EXISTS Security_SellerSessions (
    session_token VARCHAR(64) PRIMARY KEY,
    seller_id INT NOT NULL,
    user_agent VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME,
    is_active TINYINT(1) DEFAULT 1,
    CONSTRAINT FK_SellerSessions_Sellers FOREIGN KEY (seller_id) REFERENCES Membership_Sellers(id)
);

-- 3. Catalog Table
CREATE TABLE IF NOT EXISTS Catalog_Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2),
    thumbnail_url VARCHAR(500),
    stock_qty INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'available',
    CONSTRAINT FK_Products_Sellers FOREIGN KEY (seller_id) REFERENCES Membership_Sellers(id),
    CONSTRAINT CHK_Status CHECK (status IN ('available', 'not available'))
);

-- 4. Procedures & Logic
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS Membership_RegisterSeller(
    IN p_Name VARCHAR(100), IN p_Email VARCHAR(255),
    IN p_CardNumber VARCHAR(20), IN p_RawPassword VARCHAR(100)
)
BEGIN
    DECLARE v_Salt TEXT;
    DECLARE v_Hash TEXT;
    IF EXISTS (SELECT 1 FROM Membership_Sellers WHERE email = p_Email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already registered.';
    ELSE
        SET v_Salt = UUID(); 
        SET v_Hash = UPPER(HEX(SHA2(CONCAT(p_RawPassword, v_Salt), 512)));
        INSERT INTO Membership_Sellers (name, email, CardNumber, passwordHash, PasswordSalt, createdAt)
        VALUES (p_Name, p_Email, p_CardNumber, v_Hash, v_Salt, NOW());
    END IF;
END //

CREATE PROCEDURE IF NOT EXISTS Membership_LoginSeller(
    IN p_Email VARCHAR(255), IN p_InputPassword VARCHAR(100), IN p_UserAgent VARCHAR(500)
)
BEGIN
    DECLARE v_SellerID INT;
    DECLARE v_StoredHash VARCHAR(512);
    DECLARE v_StoredSalt VARCHAR(512);
    DECLARE v_NewToken VARCHAR(64);
    SELECT id, passwordHash, PasswordSalt INTO v_SellerID, v_StoredHash, v_StoredSalt
    FROM Membership_Sellers WHERE email = p_Email;
    IF v_SellerID IS NOT NULL AND v_StoredHash = UPPER(HEX(SHA2(CONCAT(p_InputPassword, v_StoredSalt), 512))) THEN
        SET v_NewToken = UUID();
        UPDATE Security_SellerSessions SET is_active = 0 WHERE seller_id = v_SellerID;
        INSERT INTO Security_SellerSessions (session_token, seller_id, user_agent, created_at, is_active)
        VALUES (v_NewToken, v_SellerID, p_UserAgent, NOW(), 1);
        SELECT 'SUCCESS' AS Status, v_NewToken AS SessionToken, v_SellerID AS SellerID;
    ELSE
        SELECT 'FAILED' AS Status, NULL AS SessionToken, NULL AS SellerID;
    END IF;
END //

DELIMITER ;

-- 5. Functions & Views
DROP FUNCTION IF EXISTS fn_GetSessionToken;
DELIMITER $$
CREATE FUNCTION fn_GetSessionToken() RETURNS VARCHAR(64) DETERMINISTIC NO SQL
BEGIN
    RETURN @SessionToken;
END $$
DELIMITER ;

CREATE OR REPLACE VIEW View_SellerProducts AS
SELECT p.* FROM Catalog_Products p
JOIN Security_SellerSessions s ON p.seller_id = s.seller_id
WHERE s.is_active = 1;

-- Seed initial data
CALL Membership_RegisterSeller('John Doe', 'test@exp.com', '5555-4444-3333-2222', '111');

DELIMITER //

-- ADD PRODUCT
CREATE PROCEDURE Catalog_usp_AddProductSecurely(
    IN p_SellerID INT, IN p_Name VARCHAR(255), 
    IN p_Price DECIMAL(10,2), IN p_Stock INT, IN p_SessionToken VARCHAR(64)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Security_SellerSessions WHERE session_token = p_SessionToken AND is_active = 1 AND seller_id = p_SellerID) THEN
        INSERT INTO Catalog_Products (seller_id, name, price, stock_qty, status)
        VALUES (p_SellerID, p_Name, p_Price, p_Stock, 'available');
        SELECT LAST_INSERT_ID() AS NewProductID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Security Violation: Invalid Session.';
    END IF;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE usp_UpdateProductSecurely(
    IN p_ProductID INT, IN p_ProductName VARCHAR(200), 
    IN p_Price DECIMAL(18,2), IN p_Stock INT, IN p_SessionToken CHAR(36)
)
BEGIN
    UPDATE Catalog_Products P
    INNER JOIN Security_SellerSessions S ON P.seller_id = S.seller_id
    SET P.name = p_ProductName, P.price = p_Price, P.stock_qty = p_Stock
    WHERE P.id = p_ProductID AND S.session_token = p_SessionToken AND S.is_active = 1;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unauthorized or Product Not Found.';
    END IF;
END //

CREATE PROCEDURE usp_DeleteProductSecurely(IN p_ProductID INT, IN p_SessionToken CHAR(36))
BEGIN
    DELETE P FROM Catalog_Products P
    INNER JOIN Security_SellerSessions S ON P.seller_id = S.seller_id
    WHERE P.id = p_ProductID AND S.session_token = p_SessionToken AND S.is_active = 1;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unauthorized or Product Not Found.';
    END IF;
END //
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE usp_LogoutSeller(
    IN p_SessionToken VARCHAR(64)
)
BEGIN
    -- 1. Check if the session exists and is active
    IF EXISTS (SELECT 1 FROM Security_SellerSessions WHERE session_token = p_SessionToken AND is_active = 1) THEN
        -- 2. Deactivate the session
        UPDATE Security_SellerSessions 
        SET is_active = 0 
        WHERE session_token = p_SessionToken;

        SELECT 'SUCCESS' AS Status, 'Session logged out' AS Message;
    ELSE
        -- 3. If token is invalid or already inactive
        SELECT 'FAILED' AS Status, 'Invalid or expired session' AS Message;
    END IF;
END $$

DELIMITER ;