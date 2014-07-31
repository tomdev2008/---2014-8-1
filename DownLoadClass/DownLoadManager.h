//
//  DownLoadManager.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoad.h"
#import "ASIFormDataRequest.h"
#import "ZL_CONST.h"
#import "LoadingView.h"

@interface DownLoadManager : NSObject <DownLoadDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL loginSuccess;
@property (nonatomic, strong) NSString *loginType;  // 登录类型
@property (nonatomic, strong) NSString *myUserId;   // 用户ID;
@property (nonatomic, strong) NSString *myUserFace; // 用户头像
@property (nonatomic, strong) NSString *groupId;    // 群组ID;
@property (nonatomic) int isFirst;
@property (nonatomic) int currentLeave; // 当前积分

// 广告
@property (nonatomic ,strong) NSMutableArray *advers;   

@property (nonatomic) BOOL neiFlag;



@property (nonatomic) int communityId;
// 预约订单号
@property (nonatomic, strong) NSString *serverOrder_Code;
// 获取小区当前的时间
@property (nonatomic, strong) NSString *serverTime;
// 订单的图片
@property (nonatomic, strong) NSString *serverImage;
// 订单内容
@property (nonatomic, strong) NSString *serverContent;

@property (strong, nonatomic) NSString *zan;

+ (DownLoadManager *)shareDownLoadManager;

// 添加下载任务
- (void)addDownLoadWithURL:(NSString *)URL andType:(NSInteger)type;

// 获取数据
- (NSMutableArray *)getDataWithKey:(NSString *)key;


// 获取小区列表
- (void)getCommunityList;
@property (nonatomic ,strong) void (^communityListBlock)(NSArray *array);
// 根据小区id获取门栋号列表接口
- (void)getCommunityTentListWithCid:(int)cid;
@property (nonatomic, strong) void (^communityTentListBlock) (NSArray *array);
// 根据小区id和门栋id获取单元列表接口
- (void)getCommunityUnityListWithCid:(int)cid andTid:(int)tid;
@property (nonatomic, strong) void (^communtityuntityListBlock) (NSArray *array);
// 根据单元id获取门号列表接口
- (void)getCommunityRommListWithUid:(int)uid;
@property (nonatomic, strong) void (^communityRoomListBlock) (NSArray *array);
// 发送注册验证码接口
- (void)sendCaptchaWithPhone:(NSString *)phone;
// 验证码验证接口
- (void)getCheckCaptchaWithPhone:(NSString *)phone andCid:(int)cid andCode:(NSString *)code;


// 用户登录
- (void)userLoginWithPhone:(NSString *)phone withPassword:(NSString *)password andDid:(NSString *)did andDtype:(int)type;
@property (nonatomic, strong) void (^loginSuccessBlcok)(User *user);
// 判断用户是否点击到最后一页
@property (nonatomic, strong) void (^lastPageBlock)();
// 用户根据手机号进行注册
- (void)userRegisterWithPhone:(NSString *)phone withPassword:(NSString *)password;
// 获取状态
@property (nonatomic, strong) NSString *status;
// 找回密码
- (void)userForgetPwd:(NSString *)phone;

// 邻居圈
// 获取邻居说列表接口
- (void)getNeighborList:(int)cid andPage:(int)page;
@property (nonatomic, strong) void (^neighborListBlock) (NSArray *array);
// 获取邻居说详情接口
- (void)getNeighborInfo:(NSString *)sid;
@property (nonatomic, strong) void (^neighborInfoBlock) (NeighobrInfo *info);
// 发布邻居说
- (void)sendNeighbor:(NSString *)content andPic:(NSString *)pic andCid:(int)cid;
// 邻居说点赞
- (void)clickZanWithSid:(int)sid;
@property (nonatomic, strong) void (^clickZanSuccessBlock)(int zanNum);
//@property (nonatomic, strong) void (^clickZanSuccessBlock)(NSString *sss);
// 屏蔽邻居说
- (void)shieldUserWithUid:(int)uid andType:(int)type;
@property (nonatomic, strong) void (^shieldUserSuccessBlock)();
// 评论
- (void)sendCommentWithMid:(NSString *)mid andPid:(NSString *)pid andContent:(NSString *)content;
// 获取邻居信息
- (void)getSayUserInfoWithUid:(NSString *)uid;
@property (nonatomic, strong) void (^sayUserInfoBlock) (User *user);
// 评论的邻居说的需要的两个数组
@property (nonatomic, strong) NSMutableArray *neiInfoArray;
@property (nonatomic, strong) NSMutableArray *neiInfoPersonArray;
// 邻居说转发        // 模块id   对象id    转发给用户id
- (void)forwardNeighborToMessage:(NSString *)mid andPid:(NSString *)pid andTo_Id:(NSString *)to_id;
// 获取我的说所
- (void)getMySayList:(NSString *)cid andUid:(NSString *)uid andPage:(int)page;

// 活动
// 活动列表
- (void)getActivityListWithCid:(NSString *)cid andPage:(NSString *)pageNo;
@property (nonatomic, strong) void (^activityBlock)(NSArray *array);
// 活动详情
- (void)getActivityDetailWithAid:(NSString *)aid;
@property (nonatomic, strong) void (^activityDetailBlock)(ActivityInfo *acti);
// 参加活动
- (void)joinActivityWithAid:(NSString *)aid andName:(NSString *)name andPhone:(NSString *)phone andRid:(NSString *)rid;
@property (nonatomic, strong) void (^joinSuccessBlock) ();

// 优惠券
// 优惠券列表
- (void)getDiscountListWithCid:(int)cid andPage:(int)page;
@property (nonatomic, strong) void (^discountBlock)(NSArray *array);
// 优惠券详情
- (void)getDiscountDetailWithCid:(int)cid;
//@property (nonatomic, strong) void (^discountDetailBlock)(NSArray *array);
@property (nonatomic, strong) void (^couponDetailBlock)(Coupon *cou);
// 优惠券数组
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
// 获取我的优惠券列表
- (void)getMyCouponList;
@property (nonatomic, strong) void (^myCouponList) (NSArray *array);

// 物业缴费
- (void)getRealPayListWithCid:(int)cid andPage:(int)page;
@property (nonatomic, strong) void (^realPayListBlock)(NSArray *array);
// 物业缴费优惠套餐
- (void)getRealPayWith:(int)rid;
@property (nonatomic, strong) void (^realPayBlock) (NSArray *array);
// 物业缴费立即支付接口
- (void)getRealPaySubmitWithRid:(NSString *)rid andPrice:(NSString *)price andStart:(NSString *)start andEnd:(NSString *)end;
@property (nonatomic, strong) void (^realPaySubmitBlock) (Order *order);


// 服务列表
- (void)getServerListWithCid:(int)cid andRecid:(int)recid andPage:(int)page;
@property (nonatomic, strong) void (^serverListBlock)(NSArray *array);
// 服务详情
- (void)getServerDetailWithsid:(int)sid;
@property (nonatomic, strong) void (^serverDetailBlock)(NSArray *array);
// 呼叫服务
- (void)sendServerWithSid:(int)sid andDtime:(NSString *)dtime andContent:(NSString *)content andRid:(int)rid;
@property (nonatomic, strong) void (^sendServerSuccessBlock)();
// 获取小区服务时间
- (void)getCommuityServerTimeWithCid:(int)cid;
@property (nonatomic, strong) void (^commuityServerTimeBlock)();
// 获取服务系列价格接口
- (void)getServerPriceListWithSid:(NSString *)sid andType:(NSString *)type;
@property (nonatomic, strong) void (^serverPriceListBlock) (NSArray *array);
// 商品型下单
- (void)getServerBookWithSid:(int)sid;
@property (nonatomic, strong) void (^serverBookBlock) (OrderInfo *orderInfo);
// 收货地址列表接口
- (void)getAddressListWith;
@property (nonatomic, strong) void (^addressBlock) (NSArray *dataArray);
// 增加收货地址接口
- (void)addAddressWithAction:(NSString *)action andCid:(NSString *)cid andRid:(NSString *)rid andName:(NSString *)name andPhone:(NSString *)phone;
@property (nonatomic, strong) void (^addAddressBlock) ();
// 提交订单接口
- (void)submitOrderWithOid:(NSString *)oid andType:(NSString *)type;
// 优惠券提交订单
- (void)getCouponWithCid:(NSString *)cid andNum:(int)num andOff:(int)off andUid:(NSString *)uid;
@property (nonatomic, strong) void (^getCouponBlock)(Order *order);
// 订单详情接口
- (void)getOrderServiceWithOid:(NSString *)oid;
@property (nonatomic, strong) void (^orderServerDetailBlock) (ServerDetail *sd);
// 业主确认订单接口
- (void)conFirmOrderWithOid:(NSString *)oid;


// 商户版
// 物业订单管理列表接口
- (void)getOrderServerListWithCid:(int)cid andMid:(int)mid andPage:(int)page;
@property (nonatomic, strong) void (^orderServerListBlock) (NSArray *array);
// 订单详情
- (void)getOrderServerInfoWithOsid:(int)osid;
@property (nonatomic, strong) void (^orderServerInfoBlock) (NSArray *array);
// 取消订单接口
- (void)orderServerCancelOrdrWithOid:(NSString *)oid;
// 下订单 和 修改订单
- (void)EditOrSendOrderService:(NSString *)oid andInfo:(NSString *)info;
@property (nonatomic, strong) void (^orderEditServer) (NSString *money);
// 填写订单接口
- (void)saveOrderEventWithOid:(NSString *)oid andInfo:(NSString *)info;
// 取消订单接口
- (void)cancleOrderWithOid:(NSString *)oid;


/******我的*****/
// 获取我的资料
- (void)getMyUserInfo;
@property (nonatomic, strong) void (^getMyUserInfoBlock) (User *user);
// 修改用户资料
- (void)updatePersonInfoWithfield:(NSString *)field andValue:(NSString *)value;
@property (nonatomic, strong) void (^updatePersonInfoSuccessBlock)();
// 获取我的服务
- (void)getMyOrderServeListWithPage:(int)page;
@property (nonatomic, strong) void (^myOrderServerListBlock)(NSArray *array);
// 获取我的优惠券列表接口
- (void)getMyCouponListWithPage:(int)page;
@property (nonatomic, strong) void (^myCouponListBlock)(NSArray *array);
// 获取我的积分详情接口
- (void)getMyPointInfo;
@property (nonatomic, strong) void (^myPointINfoBlock) (User *user);
// 我的房产
- (void)getMyRooms;
@property (nonatomic, strong) void (^myRoomList)(NSArray *array);
// 获取隐私列表
- (void)getShieldListWithType:(int)type;
@property (nonatomic, strong) void (^shieldListBlock) (NSArray *array);
// 解除屏蔽接口
- (void)delShieldWithUid:(NSString *)uid;
// 修改密码接口
- (void)editPasswordWithPassword:(NSString *)password andNewPassword:(NSString *)newPassword andRePassword:(NSString *)rePassword;

#pragma mark - 消息
// 发送信息（单聊）
- (void)sendMessageWithToId:(NSString *)toId andContent:(NSString *)content andType:(int)type;
@property (nonatomic, strong) void (^sendMessageSuccess)();
// 加载历史消息
- (void)getMessageRepastWithFrom_Id:(NSString *)from_id;
@property (nonatomic, strong) void (^messageRepastBlock) (NSArray *array);
// 获取消息列表
- (void)getTalkList;
@property (nonatomic, strong) void (^talkListBlock) (NSArray *array);
// 获取通讯录接口
- (void)getAddressBookWithCid:(NSString *)cid andGid:(NSString *)gid;
@property (nonatomic, strong) void (^addressBookBlock) (NSArray *array);
// 创建群组
- (void)createGroupMessage:(NSArray *)marray;
@property (nonatomic, strong) void (^groupMessageSuccess)();
// 退出群组
- (void)quitGroupMessage:(NSString *)gid;
@property (nonatomic, strong) void (^quetGroupSuccess) ();
// 接收新消息
- (void)accpetMessageWithFrom_Id:(NSString *)from_id;
@property (nonatomic, strong) void (^accpetMessage)(Message *message);
// 发送消息接口 (多人聊天)
- (void)sendMessageWithGid:(NSString *)gid andContent:(id)content andType:(int )type;
// 查看群信息
- (void)selectGroupInfoWithGid:(NSString *)gid;
@property (nonatomic, strong) void (^selectGroupInfo) (Group *group);
// 加载历史消息
- (void)getGroupMessageWithGid:(NSString *)gid;
// 发送文件
- (void)sendMessageWithId:(NSString *)to_id andObject:(id)objects andType:(int)type andFrom_Id:(NSString *)from_id andContentType:(int)speakType;
// 添加群组成员
- (void)addUserWithGid:(NSString *)gid andUids:(NSString *)uid;
// 置顶消息列表中指定的一条
- (void)toTopMessageWithLid:(NSString *)lid andType:(int)type;
// 屏蔽消息
- (void)shieldUserWithUid:(int)uid andType:(int)type andStyle:(int)style;

// 上传文件接口
- (void)uploadImage:(UIImage *)image andType:(int)type;
@property (nonatomic, strong) void (^uploadImageSuccess)(NSString *imageNmae);

// 优惠券排序筛选
- (void)couponSortWithOrder:(NSString *)object andType:(int)kind andCid:(int)cid;
// 修改群名称
- (void)groupNameUpdate:(NSString *)gid andName:(NSString *)gname;


@end







