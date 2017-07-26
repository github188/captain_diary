# 你这样来记忆，mapper文件跟dao接口是一一对应的，dao接口完整名对应namespace，dao的方法名对应sql中的id，就行了


mybatis 中mapper 的namespace有什么用 5
我自己定义的一个sql语句配置 可是我不懂这里的namespace有什么用 <mapper namespace="com.myweb.domain.Article"> <select id="selectAllArticle" resultType="article"> SELECT t.* FROM T_article t WHERE t.flag = '1' ORDER BY t.createtime D... 展开
lanmo970 | 浏览 23220 次
推荐于2016-03-01 17:04:57 最佳答案
楼主：
     在mybatis中，映射文件中的namespace是用于绑定Dao接口的，即面向接口编程。
当你的namespace绑定接口后，你可以不用写接口实现类，mybatis会通过该绑定自动
帮你找到对应要执行的SQL语句，如下：
假设定义了IArticeDAO接口
public interface IArticleDAO
{
   List<Article> selectAllArticle();
}
 
对于映射文件如下：
<mapper namespace="IArticleDAO">
	<select id="selectAllArticle" resultType="article">
		    SELECT t.* FROM T_article t WHERE t.flag = '1' ORDER BY t.createtime DESC
 	</select>
请注意接口中的方法与映射文件中的SQL语句的ID一一对应 。
则在代码中可以直接使用IArticeDAO面向接口编程而不需要再编写实现类。
有问题欢迎提问，满意请采纳，谢谢！
