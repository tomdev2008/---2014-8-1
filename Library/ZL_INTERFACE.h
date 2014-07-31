//
//  ZL_INTERFACE.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

// 接口
#define ZL_URLServer @"http://115.29.111.18/wty/interface/index.php/"
#define ZL_URLUpload @"http://115.29.111.18/wty/interface/Public/uploads/"

// 小区列表接口
#define URL_COMMUNITY_LIST (ZL_URLServer@"community/communityList")
// 根据小区id获取门栋列表
#define URL_COMMUNITY_TEN_LIST (ZL_URLServer@"community/tentList")
// 根据小区id和门栋号id获取单元列表接口
#define URL_COMMUNITY_UNITLIST (ZL_URLServer@"community/unitList")
// 根据单元id获取门号列表
#define URL_COMMUNITY_ROOMLIST (ZL_URLServer@"community/roomList")
// 发送注册验证码接口
#define URL_USER_SENDCAPTCHA (ZL_URLServer@"user/sendCaptcha")
// 验证码验证接口
#define URL_USER_CHECKCAPTCHA (ZL_URLServer@"user/checkCaptcha")


// 邻居说
// 获取邻居说
#define URL_NEIGHBOR (ZL_URLServer@"say/nearbySayList")
// 获取邻居说详情
#define URL_NEIGHBORINFO (ZL_URLServer@"say/sayDetail?sid=%d")
#define URL_NEIGHBORINFO_LIST (ZL_URLServer@"say/sayDetail")
// 获取邻居信息
#define URL_NEIGHOBR_INFO (ZL_URLServer@"say/userInfo")
// 获取我的邻居的说说
#define URL_NEIGHBR_SPEAK (ZL_URLServer@"say/mySayList")
// 获取他人的邻居说
#define URL_NEIGHBOR_OTHER_SPEAK (ZL_URLServer@"say/otherSayList")
// 发布邻居说
#define URL_NEIGHBOR_SEND_SPEAK (ZL_URLServer@"say/send")
// 邻居说点赞
#define URL_SAY_ZAN (ZL_URLServer@"say/zan")
// 屏蔽邻居说
#define URL_SAY_SHIELDUSER (ZL_URLServer@"say/shieldUser")
// 发布邻居说接口
#define URL_COMMENT_SEND (ZL_URLServer@"comment/send")
// 转发邻居说
#define URL_FORWORD (ZL_URLServer@"message/forward")

// 活动
// 活动列表
#define URL_ACTIVITY_LIST (ZL_URLServer@"activity/activityList")
// 活动详情
#define URL_ACTIVITY_DETAIL (ZL_URLServer@"activity/activityDetail")
// 参加活动
#define URL_JOINACTIVITY (ZL_URLServer@"activity/joinActivity")
// 填写订单信息接口
#define URL_SAVEORDEREVENT (ZL_URLServer@"orderService/saveOrderEvent")


// 优惠券
// 优惠券列表
#define URL_DISCOUNT_LIST (ZL_URLServer@"coupon/couponList")
// 优惠券详情
#define URL_DISCOUNT_DETAIL (ZL_URLServer@"coupon/couponDetail")
// 优惠券分享
#define ULR_DISCOUNT_SHARE (ZL_URLServer@"coupon/shareCoupon")
// 优惠券订单
#define URL_COUPON (ZL_URLServer@"coupon/getCoupon")
// 获取我的优惠券列表
#define URL_MYCOUPONLIST (ZL_URLServer@"coupon/myCouponList")

// 物业缴费
// 物业缴费套餐列表接口
#define URL_REAL_PAY (ZL_URLServer@"property/packageList")
// 物业缴费门栋号列表
#define URL_REAL_PAY_LIST (ZL_URLServer@"room/roomList")
// 物业缴费立即支付接口
#define URL_REAL_PAY_SUBMIT (ZL_URLServer@"property/propertySubmit")

// 服务列表
#define URL_SERVER_LIST (ZL_URLServer@"service/serviceList")
// 服务详情
#define URL_SERVER_DETAIL (ZL_URLServer@"service/serviceDetail")
// 呼叫预约
#define URL_SERVER_CALL (ZL_URLServer@"service/serviceCall")
// 获取服务系列价格接口
#define URL_SERVER_SERIES_PRICE (ZL_URLServer@"service/servicePriceList")
// 获取小区服务时间接口
#define URL_SERVER_TIME (ZL_URLServer@"community/serviceTime")
// 商品型下单接口
#define URL_SERVER_BOOK (ZL_URLServer@"service/serviceBook")
// 收货地址列表接口
#define URL_ADDRESS_LIST (ZL_URLServer@"address/addressList")
// 增加收货地址
#define URL_ADDRESS_ADD (ZL_URLServer@"address/add")
// 提交订单接口
#define URL_SUBMITORDER (ZL_URLServer@"orderService/submitOrder")
// 修改订单信息 和 下订单接口
#define URL_EDIT_ORDER_EVENT (ZL_URLServer@"orderService/editOrderEvent")
// 确认订单接口
#define URL_CONFIRM_ORDER (ZL_URLServer@"orderService/confirmOrder")

// 商户版
// 商户物业订单管理列表接口
#define URL_ORDERSERVER_LIST (ZL_URLServer@"orderService/orderServiceList")
// 订单详情
#define URL_ORDERSERVER_INFO_LIST (ZL_URLServer@"orderService/orderServiceDetail")
// 取消订单
#define URL_CANCELORDER_SERVER (ZL_URLServer@"orderService/cancelOrder")
// 填写订单信息接口
#define URL_SAVEORDEREVENT (ZL_URLServer@"orderService/saveOrderEvent")

// 我的
// 用户登录
#define URL_USERLOGIN (ZL_URLServer@"user/login")
// 用户资料
#define URL_PERSONINFO (ZL_URLServer@"user/personalInfo")
// 修改用户资料
#define URL_UPDATE_PERSONINFO (ZL_URLServer@"user/editMyInfo")
// 获取我的订单列表（服务） 接口
#define URL_MYORDERSERVER_LIST (ZL_URLServer@"orderService/myOrderServiceList")
// 获取我的优惠券列表接口
#define URL_COUPON_LIST (ZL_URLServer@"coupon/myCouponList")
// 我的积分详情接口
#define URL_MYPOINTINFO (ZL_URLServer@"user/myIntegral")
// 我的房产
#define URL_MYROOMS (ZL_URLServer@"user/myRooms")
// 获取我的隐私列表
#define URL_SHIELDLIST (ZL_URLServer@"user/shieldList")
// 解除屏蔽接口
#define URL_DELSHIELD (ZL_URLServer@"user/delShield")
// 修改密码
#define URL_CHANGEPWD (ZL_URLServer@"user/editPassword")

// 消息
// 发送信息（单聊）
#define URL_SENDMESSAGE (ZL_URLServer@"message/send")
// 加载历史消息
#define URL_REPAST_MESSAGE (ZL_URLServer@"message/repast")
// 获取消息列表
#define URL_MESSAGE_TALKLIST (ZL_URLServer@"message/talkList")
// 创建群组
#define URL_CREATE_GROUPMESSAGE (ZL_URLServer@"groupMessage/createGroup")
// 退出群组
#define URL_QUIT_GROUPMESSAGE (ZL_URLServer@"groupMessage/quitGroup")
// 获取通讯录接口
#define URL_USER_LIST (ZL_URLServer@"user/userList")
// 接收新消息
#define URL_MESSAGE_ACCPET (ZL_URLServer@"message/refresh")
// 发送消息接口 （多人聊天）
#define URL_SENDMESSAGE_MORE (ZL_URLServer@"groupMessage/send")
// 加载历史信息 （多人聊天）
#define URL_REPAST_MESSAGE_GROUP (ZL_URLServer@"groupMessage/repast")
// 查看群信息
#define URL_LOOK_GROUPINFO (ZL_URLServer@"groupMessage/viewGroup")
// 文件上传接口
#define URL_COMMON_UPLOAD (ZL_URLServer@"common/upload")
// 添加群组成员
#define URL_GROUP_ADDUSER (ZL_URLServer@"groupMessage/addUsers")
// 置顶消息列表中制定的一条
#define URL_MESSAGE_TOTOP (ZL_URLServer@"message/toTop")
// 删除指定消息列表
#define URL_MESSAGE_TODELETE (ZL_URLServer@"message/toDelete")
// 屏蔽消息
#define URL_MESSAGE_DELSHIELD (ZL_URLServer@"user/delShield")
// 修改群名称
#define URL_GROUP_NAME (ZL_URLServer@"groupMessage/renameGroup")

// 忘记密码
#define URL_FORGETPWD (ZL_URLServer@"user/forgetPwd")






