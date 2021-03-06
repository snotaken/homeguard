
####用户
####    家
####        卫士
####            switch
####                数据
####            sensor_boolean
####                数据
####            sensor_int
####                数据
####        视角
####
####标签
####

table user
    `id`            bigint
    `t_create`      datetime
    `t_update`      datetime
    `email`         varchar(320)
    `nickname`      varchar(255)
    `password_sha1` blob(20)
    `password_salt` blob(20)
    # # pw.salt.pw
    # sha1(UUID())
    # select password_sha1 = unhex(sha1(CONCAT(CONCAT('$password', `password_salt`), '$password')));
table user__home
    `id`            bigint
    `t_create`    datetime
    `t_update`    datetime
    `id_user`       bigint
    `id_home`       bigint
    `permission_r`  bit(1)
    `permission_w`  bit(1)
table home
    `id`       bigint
    `t_create` datetime
    `t_update` datetime
    `name`     char(255)
    table home__view
        `id`           bigint
        `t_create`     datetime
        `t_update`     datetime
        `name`         char(255)
    table view_data
        `id`           bigint
        `t_create`     datetime
        `t_update`     datetime
        `id_view`      bigint
        `id_data`      bigint
        `id_data_func` bigint
    table guard
        `id`        bigint
        `t_create`  datetime
        `t_update`  datetime
        `id_home`   bigint
        `name`      char(255)
        `connected` bit(1)
        table guard_data_int
            `id`           bigint
            `t_create`     datetime
            `t_update`     datetime
            `name`         char(255)
            `data`         int
            `t_lo`         int
            `t_hi`         int
            `connected`    bit(1)
table data_func
    `id`       bigint
    `t_create` datetime
    `t_update` datetime
    `id_user`  bigint
    `name`     char(255)
    `type`     enum(`badge`, `switch`, `button`)
    `script`   char(255)


 

#### home 家 ####_
    DROP TABLE IF EXISTS `home`;
    CREATE TABLE IF NOT EXISTS `home` (#__
        `id`             bigint unsigned AUTO_INCREMENT       COMMENT '账号ID',
        `t_create`       datetime        NOT NULL             COMMENT '创建时间',
        `t_update`       datetime        NOT NULL             COMMENT '更新时间',

        `name`           char(32)        NOT NULL DEFAULT ''  COMMENT '家名称',
        `key`            char(32)        NOT NULL DEFAULT ''  COMMENT '家钥匙',
        PRIMARY KEY(`id`)
    ) ENGINE=MyISAM CHARSET=utf8 COMMENT='家';
    CREATE TRIGGER `home_OnInsert` BEFORE INSERT ON `home` #__
        FOR EACH ROW
            SET NEW.`t_create` = NOW(),
                NEW.`t_update` = NOW();
    CREATE TRIGGER `home_OnUpdate` BEFORE UPDATE ON `home` #__
        FOR EACH ROW 
            SET NEW.`t_update` = NOW();

#### guard 卫士 ####_
    DROP TABLE IF EXISTS `guard`;
    CREATE TABLE IF NOT EXISTS `guard` (#__
        `id`             bigint unsigned AUTO_INCREMENT        COMMENT '账号ID',
        `t_create`       datetime        NOT NULL              COMMENT '创建时间',
        `t_update`       datetime        NOT NULL              COMMENT '更新时间',

        `id_home`        bigint unsigned                       COMMENT '家ID',

        # `index`          bigint unsigned                       COMMENT '卫士排序',
        `name`           char(64)        NOT NULL DEFAULT ''   COMMENT '卫士名称',
        
        `connected`      bit(1)          NOT NULL DEFAULT b'0' COMMENT '卫士连接状态',

        PRIMARY KEY(`id`)
    ) ENGINE=MyISAM CHARSET=utf8 COMMENT='卫士';
    CREATE TRIGGER `guard_OnInsert` BEFORE INSERT ON `guard` #__
        FOR EACH ROW
            SET NEW.`t_create` = NOW(),
                NEW.`t_update` = NOW();
    CREATE TRIGGER `guard_OnUpdate` BEFORE UPDATE ON `guard` #__
        FOR EACH ROW 
            SET NEW.`t_update` = NOW();

#### guard_switch 开关 ####_
    DROP TABLE IF EXISTS `guard_switch`;
    CREATE TABLE IF NOT EXISTS `guard_switch` (#__
        `id`             bigint unsigned AUTO_INCREMENT        COMMENT '账号ID',
        `t_create`       datetime        NOT NULL              COMMENT '创建时间',
        `t_update`       datetime        NOT NULL              COMMENT '更新时间',

        `id_guard`       bigint unsigned                       COMMENT '卫士ID',
        
        # `index`          bigint unsigned                       COMMENT '传感器排序',
        `name`           char(64)        NOT NULL DEFAULT ''   COMMENT '名称',
        `data`           bit(1)          NOT NULL DEFAULT b'0' COMMENT '数据',
        KEY `id_guard` (`id_guard`),
        PRIMARY KEY(`id`)
    ) ENGINE=MyISAM CHARSET=utf8 COMMENT='开关';
    CREATE TRIGGER `guard_switch_OnInsert` BEFORE INSERT ON `guard_switch` #__
        FOR EACH ROW
            SET NEW.`t_create` = NOW(),
                NEW.`t_update` = NOW();
    CREATE TRIGGER `guard_switch_OnUpdate` BEFORE UPDATE ON `guard_switch` #__
        FOR EACH ROW
            SET NEW.`t_update` = NOW();

#### guard_sensor_boolean_逻辑传感器表 ####_
    DROP TABLE IF EXISTS `guard_sensor_boolean`;
    CREATE TABLE IF NOT EXISTS `guard_sensor_boolean` (#__
        `id`             bigint unsigned AUTO_INCREMENT        COMMENT '账号ID',
        `t_create`       datetime        NOT NULL              COMMENT '创建时间',
        `t_update`       datetime        NOT NULL              COMMENT '更新时间',

        `id_guard`       bigint unsigned                       COMMENT '卫士ID',
        
        # `index`          bigint unsigned                       COMMENT '排序',
        `name`           char(64)        NOT NULL DEFAULT ''   COMMENT '名称',
        `data`           bit(1)          NOT NULL DEFAULT b'0' COMMENT '数据',
        KEY `id_guard` (`id_guard`),
        PRIMARY KEY(`id`)
    ) ENGINE=MyISAM CHARSET=utf8 COMMENT='';
    CREATE TRIGGER `guard_sensor_boolean_OnInsert` BEFORE INSERT ON `guard_sensor_boolean` #__
        FOR EACH ROW
            SET NEW.`t_create` = NOW(),
                NEW.`t_update` = NOW();
    CREATE TRIGGER `guard_sensor_boolean_OnUpdate` BEFORE UPDATE ON `guard_sensor_boolean` #__
        FOR EACH ROW
            SET NEW.`t_update` = NOW();

#### guard_sensor_digital_数字传感器表 ####_
    DROP TABLE IF EXISTS `guard_sensor_digital`;
    CREATE TABLE IF NOT EXISTS `guard_sensor_digital` (#__
        `id`             bigint unsigned AUTO_INCREMENT       COMMENT '账号ID',
        `t_create`       datetime        NOT NULL             COMMENT '创建时间',
        `t_update`       datetime        NOT NULL             COMMENT '更新时间',

        `id_guard`       bigint unsigned                      COMMENT '账号ID',

        `index`          bigint unsigned                      COMMENT '传感器排序',
        `name`           char(64)        NOT NULL DEFAULT ''  COMMENT '传感器名称',
        `data`           int             NOT NULL DEFAULT b'0' COMMENT '传感器数据',
        KEY `id_guard` (`id_guard`),
        PRIMARY KEY(`id`)
    ) ENGINE=MyISAM CHARSET=utf8 COMMENT='传感器表';
    CREATE TRIGGER `guard_sensor_digital_OnInsert` BEFORE INSERT ON `guard_sensor_digital` #__
        FOR EACH ROW
            SET NEW.`t_create` = NOW(),
                NEW.`t_update` = NOW();
    CREATE TRIGGER `guard_sensor_digital_OnUpdate` BEFORE UPDATE ON `guard_sensor_digital` #__
        FOR EACH ROW
            SET NEW.`t_update` = NOW();


CREATE TABLE IF NOT EXISTS `user`(
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  
) charset=utf8;

CREATE TABLE IF NOT EXISTS `guard`(

) charset=utf8;

CREATE TABLE IF NOT EXISTS `guard`(
  `id`          bigint unsigned NOT NULL AUTO_INCREMENT,
  `iduser`      bigint unsigned DEFAULT NULL,
  `t_update`    datetime        DEFAULT NULL,
  `data-name` char(32) DEFAULT NULL,
  `int32` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE `homeguard` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned DEFAULT NULL,
  `t_update` datetime DEFAULT NULL,
  `data-name` char(32) DEFAULT NULL,
  `int32` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- $sql = "SELECT count(id) count FROM homeguard where `id`=1";
-- $result = $mysqli->query($sql);
-- $row = $result->fetch_assoc();
-- if( $row["count"] == 0){
--     insert($mysqli, "卧室-客厅门卫士");
--     insert($mysqli, "卧室-客厅门卫士-公牛-Z4-插座");
--     insert($mysqli, "卧室-客厅门卫士-小夜灯");
--     insert($mysqli, "卧室-客厅门卫士-电脑桌-小吊扇");
--     insert($mysqli, "卧室-客厅门卫士-电脑桌-日光灯");
--     insert($mysqli, "卧室-客厅门卫士-红外人体感应");
--     insert($mysqli, "卧室-客厅门卫士-门框磁力感应");
--     insert($mysqli, "卧室-客厅门卫士-门框气温");
-- }
--
-- $sql = "SELECT id, `data-name`, int32 FROM homeguard";
-- $result = $mysqli->query($sql);
--
-- if ($result->num_rows > 0) {
--     // output data of each row
--     while($row = $result->fetch_assoc()) {
--         echo "id: " . $row["id"]. " - Name: " . $row["data-name"]. ", value= " . $row["int32"]. "<br>";
--     }
-- } else {
--     echo "0 results";
-- }