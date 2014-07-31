//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//



@interface Product : NSObject{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end


#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
//#define PartnerID @""
#define PartnerID @"2088302388639873"

//收款支付宝账号
//#define SellerID  @""
#define SellerID  @"1050651694@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"pd7q19a8wl1bvwyxpmhy5olfpqyu9cup"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKys++9xp+rGH7Lac+5wTAE4BqVL4uwYyTHdBn2bvvwia6GWgxiVeGTa/jS6NpvPwtuWNWQcg5nuudqto6FaucFy3eo5udDDrzYn72QVhTZZMW4h3vMxIUgL/BM+DDJlFS4fEuc/tRkRGzUKlNMxmjm1T67ONspw9aCrbmCNg5qzAgMBAAECgYAWgvbVYJvjn7DCQHicvUcrYYJ8SkhrP0/7kDUoawWbGWGuz1CIA/SOMX6yoRQ9e/iLaCnNw2nkx5qzR6/teUZ+GwQKxWEYjbDMJFvUihnoQgNfp13gfnprIDOrSSEUJ8jB9tK+djDQHeb5ppuVfMBOfxh2PSzYYvT5tYagT1V4AQJBANgkCHCw5CBtrYA3OWzzHW1uLVPhI8MvoxOsT2wQhj/5AXIkE1He9J3Zg6RF1Dz0EOl2KqhWIO5sKhly+VvyDtMCQQDMhPl5GUkyy8k4QnJkEBvragjfUuh3rzMIpbZ+MmfN85zeK42rOLW/RNKM+7J7L+PHzlSEtN66tLWJV8CpuZihAkA11iPUDfuEqE0DFr5TCOtXio33yqhhwcfY6p6NyD/oR1m42IuHZQWBG+DSViJbXF+qByjw7SMewApsdFrwMAbJAkALeYZ5ueZ2eCKRCoFaheDbI3bd+MvcMzM8z/deOzvBvWJWwMDRE3x2/8iEanbIHJa+FiB91ZwNg6gPzaGcpDIhAkAzxzkiwz5Zzf2tUlj/D+yMmrttgCQOxKhLnz1W4UI7RaBDqzqGE4Vc8sUeWUUp6wAFuAfunZJWSLB0fKuEy9jZ"
//@"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAL5rZF9Ns/i4kWsqITcIPFF4wk6jeGKF5nglHPMSDmzUryXB436wFYjEB1Q6IeEm/U4UZnr2OwZraTggMEq5dwLbtwD4W+bCug83/Tpzcfm2QaV65sMTgOI6oqpN7UAt5DH/Nd8C42yEMXu6jd3OKTocHhNlQGbA/t8T1MKr/Z3BAgMBAAECgYEAiHyzijhI+stYuGaPPkHx8jfLltBHVt9BTfbUJEpZ+poMHNU3+jO+i7RuyGmOpTLsN44Z0qMxta1B0xAHbVg4u6AZKxjnw7VAQxVoSObyDTLo7/MPzBchdlta6/VWhWLnby+fTph38oajbYQx9cHSU5ANRfisFLNQvvD7N3t+XEECQQDjU6k4hJxtm6o+YV7vvlWPD+3DXn46y3dsuJiJy5p6YkyfPYIXdfUtP80bUdPqcMhl+ZWYk8UmWrcX0+MJNiI5AkEA1nAAWh4UJsOAnL/OuQWcBx3ST753JzVsN4GfwcC0NLy/NG9qhJPojz7IorFHSBvtLvaklHXX5FMFARODtja3yQJBAIvHAFERMUIwKhDrPD270c4CpFaxvnoWa5s9MgXgXF8OHED5yAj27cdh6JL40I3hxUb2nSZRDjNUKiqLjZk3YPkCQHELaFQZqTvqMoHv59XILEHgKb/aQ8xKsHrufb7RjO6EVjQZTEkKBD6HtZN264ILHtV0Nr0BBsgaL/gqRnQnkmkCQQC+mrYOPj4toEka3lFJ26aoEi2f0iQIJZgF52DwiSU2mmyfqtbwPfh3rxxBvYi8tFpI59mIhqugNjw6jFu4LMS1"


//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
