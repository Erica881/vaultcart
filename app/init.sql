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