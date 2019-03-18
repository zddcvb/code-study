package com.yanxi.mongodb.utils;

import java.util.ArrayList;
import java.util.List;
import org.bson.Document;
import org.bson.conversions.Bson;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.yanxi.mongodb.domain.User;
/**
 * Mongodb工具类
 * @author 邹丹丹
 *
 */
public class MongodbUtil {
	/**
	 * mongodb的地址
	 */
	private String url;
	/**
	 * mongodb的端口号
	 */
	private int port;

	public MongodbUtil(String url, int port) {
		this.url = url;
		this.port = port;
	}
	/**
	 * 获得mongodatabase对象
	 * @return
	 */
	@SuppressWarnings("resource")
	private MongoDatabase getDatabase() {
		MongoClient client = new MongoClient(url, port);
		MongoDatabase database = client.getDatabase("mydemo");
		System.out.println(database.getName());
		return database;
	}
	/**
	 * 创建集合
	 * @param colName
	 * @return
	 */
	public boolean createCol(String colName) {
		MongoDatabase database = getDatabase();
		System.out.println("======createCol=======");
		database.createCollection(colName);
		return true;
	}
	/**
	 * 获得集合
	 * @param colName
	 * @return
	 */
	private MongoCollection<Document> getCol(String colName) {
		MongoDatabase database = getDatabase();
		System.out.println("======getCol=======");
		MongoCollection<Document> collection = database.getCollection(colName);
		System.out.println(collection.toString());
		return collection;
	}
	/**
	 * 插入数据
	 * @param colName
	 * @return
	 */
	public boolean insert(String colName) {
		System.out.println("======insert=======");
		MongoCollection<Document> col = getCol(colName);
		List<Document> docs = new ArrayList<>();
		for (int i = 0; i < 10; i++) {
			Document doc = new Document();
			doc.append("_id", i + 1);
			doc.append("name", "mary" + (i + 1));
			docs.add(doc);
		}
		col.insertMany(docs);
		return true;
	}
	/**
	 * 更新制定的数据
	 * @param colName
	 * @param user
	 * @return
	 */
	public boolean update(String colName, User user) {
		MongoCollection<Document> col = getCol(colName);
		Bson bson1 = new Document("_id", user.getId());
		Bson bson2 = new Document("$set", new Document("name", user.getName()));
		col.updateMany(bson1, bson2);
		return true;
	}
	/**
	 * 根据id删除单个数据
	 * @param colName
	 * @param id
	 * @return
	 */
	public boolean delete(String colName, int id) {
		MongoCollection<Document> col = getCol(colName);
		col.deleteOne(Filters.eq("_id", id));
		return true;
	}
	/**
	 * 删除所有的数据
	 * @param colName
	 * @return
	 */
	public boolean deleteAll(String colName) {
		MongoCollection<Document> col = getCol(colName);
		col.deleteMany(new Document());
		return true;
	}
	/**
	 * 查询所有的数据
	 * @param colName
	 * @return
	 */
	public List<User> findAll(String colName) {
		List<User> users = new ArrayList<>();
		MongoCollection<Document> col = getCol(colName);
		FindIterable<Document> find = col.find();
		for (Document document : find) {
			User user = new User();
			user.setId(document.getInteger("_id"));
			user.setName(document.getString("name"));
			users.add(user);
		}
		System.out.println(users);
		return users;
	}
	/**
	 * 根据id查询单个数据
	 * @param colName
	 * @param id
	 * @return
	 */
	public User findById(String colName, int id) {
		User user = new User();
		MongoCollection<Document> col = getCol(colName);
		FindIterable<Document> doc = col.find(Filters.eq("_id", id));
		user.setId(doc.first().getInteger("_id"));
		user.setName(doc.first().getString("name"));
		System.out.println(user);
		return user;
	}
	/**
	 * 根据ids查询多个数据
	 * @param colName
	 * @param ids
	 * @return
	 */
	public List<User> findByIds(String colName, int[] ids) {
		List<User> users = new ArrayList<>();
		for (int id : ids) {
			User user = findById(colName, id);
			users.add(user);
		}
		System.out.println(users);
		return users;

	}
}
