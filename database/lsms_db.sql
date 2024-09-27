-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 01, 2023 at 06:03 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lsms_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTransactionCountPerTechnician` (IN `tecID` INT)   
BEGIN
    SELECT u.id AS tech_id, u.firstname AS tech_fname, u.lastname AS tech_lname, COUNT(tl.id) AS transaction_count
    FROM users u
    LEFT JOIN transaction_list tl ON u.id = tl.tech_id
    WHERE u.id = tecID
    GROUP BY u.id;
END
$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTransactionInfo` (IN `transactionID` TEXT)   
BEGIN
    SELECT *
    FROM transaction_list
    WHERE code = transactionID;
END
$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product_list`
--

CREATE TABLE `product_list` (
  `id` int(30) NOT NULL,
  `name` text NOT NULL,
  `price` float(15,2) NOT NULL DEFAULT 0.00,
  `image_path` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `delete_flag` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_list`
--

INSERT INTO `product_list` (`id`, `name`, `price`, `image_path`, `status`, `delete_flag`) VALUES
(1, 'External Hard Disk 1Tb', 4500.00, 'uploads/products/4.png?v=1700880313', 1, 0),
(2, 'Laptop Cooling Pad', 699.00, 'uploads/products/5.png?v=1700880644', 0, 0),
(5, 'Printer', 5000.00, 'uploads/products/8.png?v=1700880819', 1, 0),
(6, 'Key Board', 799.00, 'uploads/products/9.png?v=1700880615', 1, 0),
(9, 'Web Camera', 1599.00, 'uploads/products/12.png?v=1700880844', 1, 0),
(10, 'External Speakers', 899.00, 'uploads/products/13.png?v=1700880396', 1, 0),
(12, 'Pendrives', 1599.00, 'uploads/products/15.png?v=1700880783', 1, 0),
(13, 'Monitor', 999.00, 'uploads/products/16.png?v=1700880722', 1, 0),
(14, 'Mouse', 699.00, 'uploads/products/18.png?v=1700880761', 1, 0);

--
-- Triggers `product_list`
--
DELIMITER $$
CREATE TRIGGER `before_update_transaction_products_price` BEFORE INSERT ON `product_list` FOR EACH ROW BEGIN
    IF NEW.price < 0 THEN
        SET NEW.price = 0;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `service_list`
--

CREATE TABLE `service_list` (
  `id` int(30) NOT NULL,
  `name` text NOT NULL,
  `description` text NOT NULL,
  `price` float(15,2) NOT NULL DEFAULT 0.00,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `delete_flag` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_list`
--

INSERT INTO `service_list` (`id`, `name`, `description`, `price`, `status`, `delete_flag`) VALUES
(1, 'Software Troubleshooting', 'Operating System Installation/Upgrade: Installing or upgrading the laptop\'s operating system.\r\nVirus and Malware Removal: Scanning and removing malicious software from the laptop.\r\nDriver Updates: Ensuring all necessary drivers are up to date for optimal hardware performance.\r\nSoftware Installation: Installing and configuring various software applications.', 799.00, 1, 0),
(2, 'Data Recovery and Back-up', 'Recovering lost or deleted files and data.Data Transfer: Transferring data from one device to another.', 1500.00, 1, 0),
(3, 'Hardware Repair', 'Screen Replacement: Fixing or replacing damaged or malfunctioning laptop screens.\r\nKeyboard Replacement: Repairing or replacing faulty keyboards.\r\nBattery Replacement: Replacing old or malfunctioning laptop batteries.\r\nHard Drive Replacement/Upgrade: Upgrading or replacing the laptop\'s hard drive for improved storage or performance.\r\nRAM Upgrade: Increasing the laptop\'s RAM for better multitasking capabilities.', 999.00, 1, 0),
(4, 'Virus and Malware Removal', 'Perform a comprehensive scan of your entire system using your antivirus software. This includes all files and directories.Consider using specialized anti-malware tools in addition to your antivirus software. Tools like Malwarebytes, Spybot Search & Destroy, or AdwCleaner can help detect and remove different types of malware.', 999.00, 1, 0),
(5, 'Maintenance and Cleaning', 'Dust Cleaning: Cleaning internal components to prevent overheating.\r\nCooling System Check: Ensuring that the laptop\'s cooling system is functioning properly.', 1000.00, 1, 0),
(6, 'Networking Services', 'Wi-Fi Configuration: Setting up and configuring wireless networks.\r\nNetwork Troubleshooting: Diagnosing and resolving issues related to network connectivity.', 1200.00, 1, 0),
(7, 'Performance Optimization', 'Optimizing system settings for better performance,Upgrading to a solid-state drive (SSD) for faster data access.', 1000.00, 0, 0),
(8, 'Password Recovery', 'Assist in recovering forgotten passwords for login or encrypted files.', 500.00, 1, 0),
(9, 'Peripheral Setup', 'Assist in connecting and configuring external devices such as printers, scanners, and external hard drives.', 500.00, 1, 0),
(10, 'Operating System Installation and Upgrades', 'Install a new operating system or upgrade to the latest version, ensuring a smooth transition and compatibility.', 999.00, 1, 0);

--
-- Triggers `service_list`
--
DELIMITER $$
CREATE TRIGGER `before_update_transaction_services_price` BEFORE INSERT ON `service_list` FOR EACH ROW BEGIN
    IF NEW.price < 0 THEN
        SET NEW.price = 0;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `system_info`
--

CREATE TABLE `system_info` (
  `id` int(30) NOT NULL,
  `meta_field` text NOT NULL,
  `meta_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_info`
--

INSERT INTO `system_info` (`id`, `meta_field`, `meta_value`) VALUES
(1, 'name', 'Laptop Service Management System'),
(6, 'short_name', 'Laptop Services'),
(11, 'logo', 'uploads/logo.png?v=1650507136'),
(15, 'cover', 'uploads/cover.png?v=1700305976');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_list`
--

CREATE TABLE `transaction_list` (
  `id` int(30) NOT NULL,
  `user_id` int(30) NOT NULL,
  `tech_id` int(30) DEFAULT 10,
  `code` varchar(100) NOT NULL,
  `client_name` text NOT NULL,
  `contact` text NOT NULL,
  `email` text NOT NULL,
  `address` text NOT NULL,
  `amount` float(15,2) NOT NULL DEFAULT 0.00,
  `status` tinyint(2) NOT NULL DEFAULT 0 COMMENT '\r\n0=Pending,\r\n1=On-Progress,\r\n2=Done,\r\n3=Paid,\r\n4=Not-Paid',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_list`
--

INSERT INTO `transaction_list` (`id`, `user_id`, `tech_id`, `code`, `client_name`, `contact`, `email`, `address`, `amount`, `status`, `date_created`, `date_updated`) VALUES
(8, 1, 6, '202312020001', 'Akhilesh', '2345678910', 'akhilesh@gmail.com', 'teachers colony', 2199.00, 0, '2023-12-01 22:06:46', '2023-12-01 22:06:46'),
(9, 1, 6, '202312020002', 'Dheeraj', '5678943219', 'dheeraj@gmail.com', 'RTC 2nd colony', 2098.00, 2, '2023-12-01 22:07:45', '2023-12-01 22:29:20'),
(10, 1, 6, '202312020003', 'Rohith', '3478527643', 'rohith@gmail.com', 'Panduranganagar', 2598.00, 1, '2023-12-01 22:08:27', '2023-12-01 22:29:10'),
(11, 1, 7, '202312020004', 'Yashwanth', '8765432189', 'yashwanth@gmail.com', 'Clock tower', 4698.00, 0, '2023-12-01 22:09:33', '2023-12-01 22:09:33'),
(12, 1, 7, '202312020005', 'Koushik', '5674938762', 'koushik@gmail.com', 'DB colony', 3298.00, 0, '2023-12-01 22:10:36', '2023-12-01 22:10:36'),
(13, 1, 7, '202312020006', 'Nikhil', '9876432876', 'nikhil@gmail.com', 'MF road', 2598.00, 1, '2023-12-01 22:11:21', '2023-12-01 22:29:53'),
(14, 1, 8, '202312020007', 'Gowtham', '8765432109', 'gowtham@gmail.com', 'Kukatpally', 1899.00, 1, '2023-12-01 22:12:09', '2023-12-01 22:30:23'),
(15, 1, 8, '202312020008', 'Pawan', '9876543212', 'pawan@gmail.com', 'Hitech City', 1598.00, 0, '2023-12-01 22:13:00', '2023-12-01 22:13:00'),
(16, 1, 8, '202312020009', 'Ajay', '5432876591', 'ajay@gmail.com', 'VD Road', 5499.00, 0, '2023-12-01 22:13:36', '2023-12-01 22:13:36'),
(17, 1, 9, '202312020010', 'Sathwik', '5432876519', 'sathwik@gmail.com', 'Ramnagar', 2199.00, 2, '2023-12-01 22:14:24', '2023-12-01 22:30:41'),
(18, 1, 9, '202312020011', 'Sumanth', '2345123789', 'sumanth@gmail.com', 'Diamond circle', 1699.00, 0, '2023-12-01 22:15:37', '2023-12-01 22:15:37'),
(19, 1, 9, '202312020012', 'Shankar', '7896532097', 'shankar@gmail.com', 'narayan nagar', 999.00, 0, '2023-12-01 22:16:23', '2023-12-01 22:16:23');

--
-- Triggers `transaction_list`
--
DELIMITER $$
CREATE TRIGGER `before_transaction_insert` BEFORE INSERT ON `transaction_list` FOR EACH ROW BEGIN
  IF NEW.tech_id IS NULL THEN
    SET NEW.tech_id = 10;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_transaction_update` BEFORE UPDATE ON `transaction_list` FOR EACH ROW BEGIN
  IF NEW.tech_id IS NULL THEN
    SET NEW.tech_id = 10;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_transaction` BEFORE UPDATE ON `transaction_list` FOR EACH ROW BEGIN
    SET NEW.`date_updated` = CURRENT_TIMESTAMP();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_products`
--

CREATE TABLE `transaction_products` (
  `transaction_id` int(30) NOT NULL,
  `product_id` int(30) NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `price` float(15,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_products`
--

INSERT INTO `transaction_products` (`transaction_id`, `product_id`, `qty`, `price`) VALUES
(8, 13, 1, 999.00),
(9, 6, 2, 799.00),
(10, 9, 1, 1599.00),
(11, 12, 2, 1599.00),
(12, 10, 2, 899.00),
(13, 9, 1, 1599.00),
(14, 14, 1, 699.00),
(15, 6, 1, 799.00),
(16, 1, 1, 4500.00),
(17, 13, 1, 999.00),
(18, 14, 1, 699.00);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_services`
--

CREATE TABLE `transaction_services` (
  `transaction_id` int(30) NOT NULL,
  `service_id` int(30) NOT NULL,
  `price` float(15,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_services`
--

INSERT INTO `transaction_services` (`transaction_id`, `service_id`, `price`) VALUES
(8, 6, 1200.00),
(9, 8, 500.00),
(10, 4, 999.00),
(11, 2, 1500.00),
(12, 2, 1500.00),
(13, 10, 999.00),
(14, 6, 1200.00),
(15, 1, 799.00),
(16, 4, 999.00),
(17, 6, 1200.00),
(18, 5, 1000.00),
(19, 10, 999.00);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(50) NOT NULL,
  `firstname` varchar(250) NOT NULL,
  `lastname` varchar(250) NOT NULL,
  `email` text NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `username`, `password`, `type`, `date_added`, `date_updated`) VALUES
(1, 'Vishwa', 'Charan', 'vishwa@gmail.com', 'vishwa', '11f7ab9b92142ede2851279160b6edaf', 1, '2021-01-20 14:02:37', '2023-11-25 02:48:43'),
(6, 'tech', '1', 'tech1@gmail.com', 'tech1', 'f894dcca6eae352314f2154d79bc1687', 2, '2023-11-16 12:35:38', '2023-11-16 12:35:38'),
(7, 'tech', '2', 'tech2@gmail.com', 'tech2', '6fb9a48ef96dafc705cfcc04ac4eeffe', 2, '2023-11-16 12:35:57', '2023-11-16 12:35:57'),
(8, 'tech', '4', 'tech4@gmail.com', 'tech4', 'be931f90f29439ef5d3d496bf3a0c982', 2, '2023-11-18 09:42:35', '2023-11-18 09:42:35'),
(9, 'tech', '5', 'tech5@gmail.com', 'tech5', '3ea3457f6b329fcb2ffb54c1ae0a10c6', 2, '2023-11-18 10:12:51', '2023-11-18 10:12:51'),
(10, 'Default', 'Technician', 'defaultechnician@gmail.com', 'default', 'c21f969b5f03d33d43e04f8f136e7682', 2, '2023-12-01 19:43:05', '2023-12-01 19:43:05');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `before_update_users` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    SET NEW.date_updated = CURRENT_TIMESTAMP();
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `product_list`
--
ALTER TABLE `product_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service_list`
--
ALTER TABLE `service_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `system_info`
--
ALTER TABLE `system_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction_list`
--
ALTER TABLE `transaction_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `tech_id` (`tech_id`);

--
-- Indexes for table `transaction_products`
--
ALTER TABLE `transaction_products`
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `service_id` (`product_id`);

--
-- Indexes for table `transaction_services`
--
ALTER TABLE `transaction_services`
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `product_list`
--
ALTER TABLE `product_list`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `service_list`
--
ALTER TABLE `service_list`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `system_info`
--
ALTER TABLE `system_info`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `transaction_list`
--
ALTER TABLE `transaction_list`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaction_list`
--
ALTER TABLE `transaction_list`
  ADD CONSTRAINT `tech_id_fk_tl` FOREIGN KEY (`tech_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_id_fk_tl` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `transaction_products`
--
ALTER TABLE `transaction_products`
  ADD CONSTRAINT `product_id_fk_tp` FOREIGN KEY (`product_id`) REFERENCES `product_list` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `transaction_id_fk_tp` FOREIGN KEY (`transaction_id`) REFERENCES `transaction_list` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `transaction_services`
--
ALTER TABLE `transaction_services`
  ADD CONSTRAINT `service_id_fk_ts` FOREIGN KEY (`service_id`) REFERENCES `service_list` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `transaction_id_fk_ts` FOREIGN KEY (`transaction_id`) REFERENCES `transaction_list` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
