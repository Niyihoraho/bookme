-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 07, 2025 at 12:48 PM
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
-- Database: `booking_servise`
--

-- --------------------------------------------------------

--
-- Table structure for table `availability`
--

CREATE TABLE `availability` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dayFrom` varchar(191) NOT NULL,
  `dayTo` varchar(191) NOT NULL,
  `hourFrom` varchar(191) NOT NULL,
  `hourTo` varchar(191) NOT NULL,
  `unavailable` tinyint(1) NOT NULL DEFAULT 0,
  `reason` varchar(191) DEFAULT NULL,
  `emergency` tinyint(1) NOT NULL DEFAULT 0,
  `duration` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `availability`
--

INSERT INTO `availability` (`id`, `userId`, `dayFrom`, `dayTo`, `hourFrom`, `hourTo`, `unavailable`, `reason`, `emergency`, `duration`, `createdAt`, `updatedAt`) VALUES
(1, 1, 'Monday', 'Saturday', '08:00', '18:00', 0, '', 0, NULL, '2025-09-28 16:56:42.346', '2025-09-28 16:56:42.346'),
(2, 4, 'Monday', 'Saturday', '08:00', '18:00', 0, '', 0, NULL, '2025-09-29 05:14:55.089', '2025-09-29 05:14:55.089'),
(3, 3, 'Monday', 'Sunday', '00:00', '12:00', 0, '', 0, NULL, '2025-09-29 05:51:13.241', '2025-09-29 05:51:13.241');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `message` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fooddelivery`
--

CREATE TABLE `fooddelivery` (
  `id` int(11) NOT NULL,
  `category` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `price` double NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `foodDescription` varchar(191) DEFAULT NULL,
  `foodImage` varchar(191) DEFAULT NULL,
  `ingredients` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fooddelivery`
--

INSERT INTO `fooddelivery` (`id`, `category`, `name`, `price`, `userId`, `createdAt`, `foodDescription`, `foodImage`, `ingredients`) VALUES
(1, 'Breakfast', 'Banana Pancakes', 2500, 4, '2025-09-29 05:13:13.895', 'Fluffy pancakes made with fresh bananas', '1759122793852-631866831.jpg', 'Bananas, Flour, Eggs, Milk, Butter'),
(2, 'Snacks', 'Fruit Salad Cup', 5000, 3, '2025-09-29 05:31:21.284', 'Freshly chopped fruit mix in a cup', '1759123881227-570950487.jpg', 'Pineapple, Mango, Watermelon, Banana, Orange');

-- --------------------------------------------------------

--
-- Table structure for table `passwordreset`
--

CREATE TABLE `passwordreset` (
  `id` int(11) NOT NULL,
  `email` varchar(191) NOT NULL,
  `otp` varchar(191) NOT NULL,
  `expiresAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` int(11) NOT NULL,
  `firstName` varchar(191) NOT NULL,
  `lastName` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phoneNumber` varchar(191) NOT NULL,
  `datetime` datetime(3) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `userId` int(11) NOT NULL,
  `isAvailable` tinyint(1) NOT NULL DEFAULT 1,
  `unavailableReason` varchar(191) DEFAULT NULL,
  `isTimeBooked` tinyint(1) NOT NULL DEFAULT 0,
  `conflictWithId` int(11) DEFAULT NULL,
  `bookingLocation` varchar(191) DEFAULT NULL,
  `paymentMethod` varchar(191) DEFAULT NULL,
  `transactionRef` varchar(191) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `currency` varchar(191) DEFAULT NULL,
  `gatewayResponse` varchar(191) DEFAULT NULL,
  `message` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id`, `firstName`, `lastName`, `email`, `phoneNumber`, `datetime`, `createdAt`, `status`, `userId`, `isAvailable`, `unavailableReason`, `isTimeBooked`, `conflictWithId`, `bookingLocation`, `paymentMethod`, `transactionRef`, `amount`, `currency`, `gatewayResponse`, `message`) VALUES
(1, 'TUYISENGE ', 'Elysée', 'tuyisengeelysee1@gmail.com', '+250781888904', '2025-10-03 06:57:00.000', '2025-09-28 17:07:24.069', 'Done', 1, 1, NULL, 0, NULL, 'Provider\'s Location (Huye)', 'MTN', 'TEST_1759079297641', 15000, 'USD', NULL, 'Payment successfu'),
(2, 'TUYISENGE ', 'Elysée', 'tuyisengeelysee1@gmail.com', '+250781888904', '2025-09-29 08:15:00.000', '2025-09-29 05:15:58.675', 'paid', 4, 1, NULL, 0, NULL, 'Provider\'s Location (Huye)', 'MTN', 'TEST_1759123293945', 6000, 'USD', NULL, 'Payment successfu');

-- --------------------------------------------------------

--
-- Table structure for table `paymentfooddelivery`
--

CREATE TABLE `paymentfooddelivery` (
  `id` int(11) NOT NULL,
  `paymentId` int(11) NOT NULL,
  `foodDeliveryId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `initialPrice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `paymentfooddelivery`
--

INSERT INTO `paymentfooddelivery` (`id`, `paymentId`, `foodDeliveryId`, `quantity`, `initialPrice`) VALUES
(1, 2, 1, 2, 2500);

-- --------------------------------------------------------

--
-- Table structure for table `paymentservice`
--

CREATE TABLE `paymentservice` (
  `id` int(11) NOT NULL,
  `paymentId` int(11) NOT NULL,
  `serviceId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `initialPrice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `paymentservice`
--

INSERT INTO `paymentservice` (`id`, `paymentId`, `serviceId`, `quantity`, `initialPrice`) VALUES
(1, 1, 1, 1, 15000);

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `id` int(11) NOT NULL,
  `category` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `images` varchar(191) NOT NULL,
  `price` double NOT NULL,
  `location` varchar(191) NOT NULL,
  `description` varchar(191) NOT NULL,
  `duration` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` int(11) NOT NULL,
  `locationType` enum('CUSTOM','PROVIDER','HYBRID') NOT NULL DEFAULT 'PROVIDER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`id`, `category`, `name`, `images`, `price`, `location`, `description`, `duration`, `createdAt`, `updatedAt`, `userId`, `locationType`) VALUES
(1, 'Massage', 'Hot Stone Massage', '1759078586363-771396580.jpg', 15000, 'Huye', 'Smooth, heated stones are used to ease muscle stiffness and increase circulation.', 240, '2025-09-28 16:56:26.510', '2025-09-28 16:56:26.510', 1, 'HYBRID'),
(2, 'Massage', 'Body To body', '1759124263003-338046987.webp', 15000, 'Huye', 'Enjoy a relaxing massage together with your partner in a serene environment.', 120, '2025-09-29 05:37:14.104', '2025-09-29 05:37:43.016', 3, 'HYBRID');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(191) DEFAULT NULL,
  `businessName` varchar(191) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `profileImage` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `role` varchar(191) NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `businessName`, `email`, `phone`, `password`, `profileImage`, `createdAt`, `updatedAt`, `approved`, `role`) VALUES
(1, 'Casahotel12_', 'Casa Hotel ', 'casahotel@gmail.com', '0781888904', 'Telysee2002@', '1759078507462-271613916.png', '2025-09-28 16:52:29.417', '2025-09-28 16:55:07.491', 1, 'user'),
(2, 'system-admin', 'System', 'imanirumvaolivier20@gmail.com', 'admin-1759082502779', 'Admin123', 'https://placehold.co/400x400/EEE/31343C?text=Admin', '2025-09-28 18:01:42.799', '2025-09-28 18:07:02.745', 1, 'admin'),
(3, 'golf_', 'Golf Eden Hotel', 'golfedenhotel@gmail.com', '0791056392', 'Telysee2002@', '1759123959952-943485321.JPG', '2025-09-29 04:47:29.555', '2025-09-29 05:32:40.016', 1, 'user'),
(4, 'umucyo', 'Umucyo Resto Bar', 'umucyoresto@gmail.com', '0787137638', 'Telysee2002@', '1759122819419-877730275.jpg', '2025-09-29 05:02:21.337', '2025-09-29 05:13:39.477', 1, 'user');

-- --------------------------------------------------------

--
-- Table structure for table `_fooddeliverypayments`
--

CREATE TABLE `_fooddeliverypayments` (
  `A` int(11) NOT NULL,
  `B` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('1302fe83-7732-497b-b751-d5f23690852f', '9fdee88a425fe535acd1618cf410705d2a749054599cf5013d72fbb326657193', '2025-09-28 16:47:24.204', '20250704073730_add_password_reset', NULL, NULL, '2025-09-28 16:47:24.191', 1),
('20a84f49-28bd-4a17-ac3c-2bcdeb6c5f5b', '7604d097d914c69be5747592a169e84f7eae6bab663c5410df57199cfeeb8a58', '2025-09-28 16:47:24.218', '20250705140535_add_feedback', NULL, NULL, '2025-09-28 16:47:24.206', 1),
('2421c738-e774-426e-91e7-fe2de93a493b', '1a3ec3b555ae8b19ee8b568eb97a1aaad74791029d3b2372d5e1446751253d80', '2025-09-28 16:47:24.978', '20250730165430_remove_amount_quantity', NULL, NULL, '2025-09-28 16:47:24.967', 1),
('3e7b6e11-3722-4182-9022-82d8c589d1e6', '58de9b7ca8c6f10076441ee20db2009ab710c2a3c1615c074018d8d89063d57c', '2025-09-28 16:47:24.135', '20250621154404_init', NULL, NULL, '2025-09-28 16:47:23.671', 1),
('4d4b6b15-bfc3-4d5f-a3ad-dbc32f837645', 'eee2146b2d46e06e6cdaf816bbb233f56ccb9a799ddf3e5dd9526e5bb3e0ea8a', '2025-09-28 16:47:24.930', '20250722105239_add_quantity_fields', NULL, NULL, '2025-09-28 16:47:24.568', 1),
('535149f9-c0d3-42cb-8897-638ccef39c64', '62b13e57cde393447547083b9df52d30ddee02b196bbec55a017c845ec75fba1', '2025-09-28 16:47:24.388', '20250720140108_remove_payment_method', NULL, NULL, '2025-09-28 16:47:24.375', 1),
('5ccf7e16-8cdc-4179-b674-300d9d0203a1', '6444ba6a9a0d420789b70feb766722976d3477e44611a26d7f5a8020de68c38c', '2025-09-28 16:47:24.965', '20250730163754_add_afripay_fields', NULL, NULL, '2025-09-28 16:47:24.953', 1),
('68bfce1c-29f7-44f7-9613-cc49ab0b1e6a', '6f41187589e8c8b85466a9a41b73347318ea6e0004b0c5f197f049ba8fe7a65b', '2025-09-28 16:47:24.190', '20250703163010_init', NULL, NULL, '2025-09-28 16:47:24.163', 1),
('69acf607-1d72-4d10-b943-8fe4cc0f403b', '14e35293fe0b2e24eb1320e906056a5bf4c747a40c6d6b3633ae19ef0cf9930a', '2025-09-28 16:47:24.951', '20250729154821_add_initial_price_to_payment_items', NULL, NULL, '2025-09-28 16:47:24.932', 1),
('78eb0469-aa62-4ebe-9ba4-aa096c34f041', 'a3cc745aeccb1bbe21965ea7812d2ac395cc0b397c84788eba79173499fa568a', '2025-09-28 16:47:24.251', '20250706111033_remove_screenshot_from_feedback', NULL, NULL, '2025-09-28 16:47:24.220', 1),
('80150b17-81f7-4069-9f12-d334cdff7c5a', 'de960aa8213af51d915f68a3014ea2de9f2bb93ad0d11f7f3209090a14aa844c', '2025-09-28 16:47:24.566', '20250722100606_add_payment_quantity', NULL, NULL, '2025-09-28 16:47:24.554', 1),
('8b827ceb-468e-4071-906c-209edc132e10', '37b82d452cf1f83f83581fc0aede654c37c02a1dc2459c66e494244aa53849f9', '2025-09-28 16:47:24.373', '20250715190802_add_food_fields', NULL, NULL, '2025-09-28 16:47:24.359', 1),
('92a39ec8-e6d5-4a56-8b45-e72b4da10aab', 'a594168453407a821275dc19877780c4492d42a9632d1e1f05c217a64d21604d', '2025-09-28 17:03:34.528', '20250928170332_add_payment_details', NULL, NULL, '2025-09-28 17:03:34.515', 1),
('cb9dabee-6fd6-47d8-b307-d1278059a039', 'c54f417254c962aa12d82c1a2f616ce3568cc4961b4480dd5e821f3c01c03a4f', '2025-09-28 16:47:24.552', '20250721152235_add_food_delivery_payments', NULL, NULL, '2025-09-28 16:47:24.390', 1),
('e161b830-46e9-40c6-97d1-5440550f0a54', '17840f90b14742ac5043b74ca0ed3d2cae0de7a8444ce3b13cfc4e1c8f060ddb', '2025-09-28 16:47:24.161', '20250702124313_add_banned_to_user', NULL, NULL, '2025-09-28 16:47:24.150', 1),
('f3e415d4-51cf-47b8-b022-8a603963d30d', 'fa914defb63c094a257b161cd54b8a811b8fccfcae54404181d468ce7a77ce82', '2025-09-28 16:47:24.357', '20250714183114_add_food_delivery_user_relation', NULL, NULL, '2025-09-28 16:47:24.253', 1),
('f4e7b3fc-7c8e-4798-9c89-0cb80f4f6a9e', '9cd822f868da61ea0abdacb3c586290078ba58a63212dee9616d7151b864a7b9', '2025-09-28 16:47:24.149', '20250702093659_add_role_to_user', NULL, NULL, '2025-09-28 16:47:24.136', 1);

-- --------------------------------------------------------

--
-- Table structure for table `_servicepayments`
--

CREATE TABLE `_servicepayments` (
  `A` int(11) NOT NULL,
  `B` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `availability`
--
ALTER TABLE `availability`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Availability_userId_fkey` (`userId`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fooddelivery`
--
ALTER TABLE `fooddelivery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FoodDelivery_userId_fkey` (`userId`);

--
-- Indexes for table `passwordreset`
--
ALTER TABLE `passwordreset`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Payment_userId_fkey` (`userId`);

--
-- Indexes for table `paymentfooddelivery`
--
ALTER TABLE `paymentfooddelivery`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `PaymentFoodDelivery_paymentId_foodDeliveryId_key` (`paymentId`,`foodDeliveryId`),
  ADD KEY `PaymentFoodDelivery_foodDeliveryId_fkey` (`foodDeliveryId`);

--
-- Indexes for table `paymentservice`
--
ALTER TABLE `paymentservice`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `PaymentService_paymentId_serviceId_key` (`paymentId`,`serviceId`),
  ADD KEY `PaymentService_serviceId_fkey` (`serviceId`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Service_userId_fkey` (`userId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `User_email_key` (`email`),
  ADD UNIQUE KEY `User_phone_key` (`phone`),
  ADD UNIQUE KEY `User_username_key` (`username`),
  ADD UNIQUE KEY `User_businessName_key` (`businessName`);

--
-- Indexes for table `_fooddeliverypayments`
--
ALTER TABLE `_fooddeliverypayments`
  ADD UNIQUE KEY `_FoodDeliveryPayments_AB_unique` (`A`,`B`),
  ADD KEY `_FoodDeliveryPayments_B_index` (`B`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `_servicepayments`
--
ALTER TABLE `_servicepayments`
  ADD UNIQUE KEY `_ServicePayments_AB_unique` (`A`,`B`),
  ADD KEY `_ServicePayments_B_index` (`B`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `availability`
--
ALTER TABLE `availability`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fooddelivery`
--
ALTER TABLE `fooddelivery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `passwordreset`
--
ALTER TABLE `passwordreset`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `paymentfooddelivery`
--
ALTER TABLE `paymentfooddelivery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `paymentservice`
--
ALTER TABLE `paymentservice`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `availability`
--
ALTER TABLE `availability`
  ADD CONSTRAINT `Availability_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `fooddelivery`
--
ALTER TABLE `fooddelivery`
  ADD CONSTRAINT `FoodDelivery_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `Payment_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `paymentfooddelivery`
--
ALTER TABLE `paymentfooddelivery`
  ADD CONSTRAINT `PaymentFoodDelivery_foodDeliveryId_fkey` FOREIGN KEY (`foodDeliveryId`) REFERENCES `fooddelivery` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `PaymentFoodDelivery_paymentId_fkey` FOREIGN KEY (`paymentId`) REFERENCES `payment` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `paymentservice`
--
ALTER TABLE `paymentservice`
  ADD CONSTRAINT `PaymentService_paymentId_fkey` FOREIGN KEY (`paymentId`) REFERENCES `payment` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `PaymentService_serviceId_fkey` FOREIGN KEY (`serviceId`) REFERENCES `service` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `service`
--
ALTER TABLE `service`
  ADD CONSTRAINT `Service_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `_fooddeliverypayments`
--
ALTER TABLE `_fooddeliverypayments`
  ADD CONSTRAINT `_FoodDeliveryPayments_A_fkey` FOREIGN KEY (`A`) REFERENCES `fooddelivery` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `_FoodDeliveryPayments_B_fkey` FOREIGN KEY (`B`) REFERENCES `payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `_servicepayments`
--
ALTER TABLE `_servicepayments`
  ADD CONSTRAINT `_ServicePayments_A_fkey` FOREIGN KEY (`A`) REFERENCES `payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `_ServicePayments_B_fkey` FOREIGN KEY (`B`) REFERENCES `service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
