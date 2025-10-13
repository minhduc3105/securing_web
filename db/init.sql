-- Đảm bảo sử dụng database đã được tạo tự động bởi Docker Entrypoint
USE securing_web;

-- Bắt đầu: Tắt kiểm tra Khóa ngoại để dễ dàng tạo bảng theo thứ tự bất kỳ.
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------
-- 1. TẠO BẢNG 'users'
-- ------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
                         `username` varchar(50) NOT NULL,
                         `password` varchar(100) NOT NULL,
                         `enabled` tinyint(1) NOT NULL,
                         PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chèn dữ liệu cho bảng 'users'
INSERT INTO `users` VALUES
                        ('admin','$2a$10$0.vRuxBcxGh9UPS57VNiLO8ScUmZRG05mKa1Oy6eUK/nyvOwicl0O',1),
                        ('user','$2a$10$EguBjTjvI.oKnwZ5b01KDeFkv91RpBai7RIXyBb.mSQAXKbOsjGn6',1);


-- ------------------------------------------------------
-- 2. TẠO BẢNG 'authorities'
-- ------------------------------------------------------
DROP TABLE IF EXISTS `authorities`;
CREATE TABLE `authorities` (
                               `username` varchar(50) NOT NULL,
                               `authority` varchar(50) NOT NULL,
                               KEY `username` (`username`),
                               CONSTRAINT `authorities_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chèn dữ liệu cho bảng 'authorities'
INSERT INTO `authorities` VALUES
                              ('user','ROLE_USER'),
                              ('admin','ROLE_ADMIN');

-- Kết thúc: Bật lại kiểm tra Khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;