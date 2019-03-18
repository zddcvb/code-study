package com.yanxi.mp.util;

import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.rules.DbType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;

public class MpGenerator {
	public static void main(String[] args) {
		// 1、配置全局参数
		GlobalConfig config = new GlobalConfig();
		config.setOutputDir("G:\\workplace\\maven\\mp-generator\\src\\main\\java\\").setFileOverride(true)
				.setActiveRecord(true).setIdType(IdType.AUTO).setBaseResultMap(true).setBaseColumnList(true)
				.setEnableCache(true).setServiceName("%sService").setServiceImplName("%sServiceImpl")
				.setMapperName("%sMapper").setControllerName("%sController").setXmlName("%sMapper");

		// 2、配置数据源
		DataSourceConfig dataSourceConfig = new DataSourceConfig();
		dataSourceConfig.setDbType(DbType.MYSQL)
				.setDriverName("com.mysql.jdbc.Driver")
				.setUrl("jdbc:mysql://127.0.0.1:3306/testboot")
				.setUsername("root").setPassword("root");

		// 3、策略配置
		StrategyConfig strategyConfig = new StrategyConfig();
		strategyConfig.setNaming(NamingStrategy.underline_to_camel);

		// 4、包配置
		PackageConfig packageConfig = new PackageConfig();
		packageConfig.setParent("com.yanxi.mp").setController("controller").setMapper("mapper").setEntity("bean")
				.setService("service").setServiceImpl("service.impl").setXml("mapper");

		// 5、自动生成
		AutoGenerator autoGenerator = new AutoGenerator();
		autoGenerator.setGlobalConfig(config).setDataSource(dataSourceConfig).setStrategy(strategyConfig)
				.setPackageInfo(packageConfig);

		autoGenerator.execute();
	}
}
