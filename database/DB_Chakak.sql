DROP DATABASE IF EXISTS chakak;
CREATE DATABASE IF NOT EXISTS chakak DEFAULT CHARACTER SET utf8mb4;
USE chakak;

DROP TABLE IF EXISTS REPORT_IMAGE;
DROP TABLE IF EXISTS COMMENT;
DROP TABLE IF EXISTS REPORT;
DROP TABLE IF EXISTS NOTICE;
DROP TABLE IF EXISTS USER;

-- USER
CREATE TABLE `USER` (
  USER_ID     VARCHAR(100) NOT NULL,
  PASSWORD    VARCHAR(255) NOT NULL,
  EMAIL       VARCHAR(255) NOT NULL,
  NAME        VARCHAR(255) NOT NULL,
  ROLE        ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
  CREATED_AT  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATED_AT  DATETIME NULL,
  IS_DELETED  BOOLEAN NOT NULL DEFAULT FALSE,
  DELETED_AT  DATETIME NULL,
  PRIMARY KEY (USER_ID)
) COMMENT = '회원';

-- REPORT
CREATE TABLE REPORT (
  REPORT_ID       BIGINT NOT NULL AUTO_INCREMENT,
  USER_ID         VARCHAR(100) NOT NULL,
  TITLE           VARCHAR(200) NOT NULL,
  VEHICLE_NUMBER  VARCHAR(50) NOT NULL,
  REPORT_TIME     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  VIOLATION_TYPE  VARCHAR(50) NOT NULL,
  LATITUDE        DOUBLE NULL,
  LONGITUDE       DOUBLE NULL,
  ADDRESS         VARCHAR(255) NULL,
  DESCRIPTION     TEXT NULL,
  CREATED_AT      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATED_AT      DATETIME NULL,
  VIEW_CNT        BIGINT DEFAULT 0,
  LOCATION_TYPE   VARCHAR(20) null,
  PRIMARY KEY (REPORT_ID),
  FOREIGN KEY (USER_ID) REFERENCES USER(USER_ID)
) COMMENT = '신고';

-- COMMENT
CREATE TABLE COMMENT (
  COMMENT_ID   BIGINT NOT NULL AUTO_INCREMENT,
  REPORT_ID    BIGINT NOT NULL,
  USER_ID      VARCHAR(100) NOT NULL,
  CONTENT      TEXT NOT NULL,
  CREATED_AT   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATED_AT   DATETIME NULL,
  PRIMARY KEY (COMMENT_ID),
  FOREIGN KEY (REPORT_ID) REFERENCES REPORT(REPORT_ID),
  FOREIGN KEY (USER_ID) REFERENCES USER(USER_ID)
) COMMENT = '댓글';

-- REPORT_IMAGE
CREATE TABLE REPORT_IMAGE (
  IMG_ID      BIGINT NOT NULL AUTO_INCREMENT,
  REPORT_ID   BIGINT NOT NULL,
  IMG_PATH    VARCHAR(1000) NOT NULL,
  CREATED_AT  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (IMG_ID),
  FOREIGN KEY (REPORT_ID) REFERENCES REPORT(REPORT_ID)
) COMMENT = '신고 사진';

-- REACTION
CREATE TABLE REACTION (
  REACTION_ID     BIGINT NOT NULL AUTO_INCREMENT,
  USER_ID         VARCHAR(100) NOT NULL,
  REPORT_ID       BIGINT NOT NULL,
  REACTION_TYPE   ENUM('LIKE', 'DISLIKE') NOT NULL,
  CREATED_AT      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (REACTION_ID),
  FOREIGN KEY (USER_ID) REFERENCES USER(USER_ID),
  FOREIGN KEY (REPORT_ID) REFERENCES REPORT(REPORT_ID)
) COMMENT = '사용자 반응';

-- NOTICE
CREATE TABLE NOTICE (
  NOTICE_ID   BIGINT NOT NULL AUTO_INCREMENT,
  TITLE       VARCHAR(500) NOT NULL,
  CONTENT     TEXT NOT NULL,
  VIEW_COUNT  INT NOT NULL DEFAULT 0,
  CREATED_ID  VARCHAR(100) NOT NULL,
  UPDATED_ID  VARCHAR(100) NULL,
  CREATED_AT  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATED_AT  DATETIME NULL,
  PRIMARY KEY (NOTICE_ID),
  FOREIGN KEY (CREATED_ID) REFERENCES USER(USER_ID),
  FOREIGN KEY (UPDATED_ID) REFERENCES USER(USER_ID)
) COMMENT = '공지사항';