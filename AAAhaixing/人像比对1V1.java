import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;


public class TestMain {
    static String url = "https://service.eidcc.com/api";
    static String account="xxx"; //账号
    static String key = "xxx"; //密码
	public static void main(String[] args){
        String acode = "900510";//代码（固定不变）
        String firstImage = "xxx"; //第一张图片 jpg base64
        String secondImage = "xxx"; //第二张图片 jpg base64
        String param = "firstimage=" + firstImage + "&secondimage=" + secondImage;
        String sign = md5(acode + param + account + md5(key));//生成签名
       
        String post_data = null;
		try {
			post_data = "acode=" + acode + "&param=" + URLEncoder.encode(param, "UTF-8") + "&account=" 
					+ account + "&sign=" + sign;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return;
		}
		String json = postHtml(url, post_data);
		//返回的 json 即为查询到的信息
		System.out.println(json);
    }
    
    static String md5(String text) {
		byte[] bts;
		try {
			bts = text.getBytes("UTF-8");
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] bts_hash = md.digest(bts);
			StringBuffer buf = new StringBuffer();
			for (byte b : bts_hash) {
				buf.append(String.format("%02X", b & 0xff));
			}
			return buf.toString();
		} catch (java.io.UnsupportedEncodingException e) {
			e.printStackTrace();
			return "";
		} catch (java.security.NoSuchAlgorithmException e) {
			e.printStackTrace();
			return "";
		}
	}
    
   static String postHtml(String url, String postData) {
		try {
			URL obj = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
            conn.setDoInput(true);
            PrintWriter out = new PrintWriter(conn.getOutputStream());
            out.print(postData);
            out.flush();
			BufferedReader br = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			StringBuffer response = new StringBuffer();
			
			String line;
			while ((line = br.readLine()) != null) {
				response.append(line);
			}
			br.close();
			return response.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}


}
