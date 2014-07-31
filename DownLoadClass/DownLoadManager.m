//
//  DownLoadManager.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"
#import "AppUtil.h"
#define HIDE_LOAD_VIEW ([_loadingView loadingViewDispear:0];)

@implementation DownLoadManager
{
    NSMutableDictionary *_taskDict; //  任务队列
    NSMutableDictionary *_dataDict; //  缓存字典
    NSMutableArray *_dataArray;
    NSString *price_type;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskDict = [[NSMutableDictionary alloc] init];
        _dataDict = [[NSMutableDictionary alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        _neiInfoArray = [[NSMutableArray alloc] init];
        _neiInfoPersonArray = [[NSMutableArray alloc] init];
        _userArray = [[NSMutableArray alloc] init];
        _commentArray = [[NSMutableArray alloc] init];
        _pictureArray = [[NSMutableArray alloc] init];
        _advers = [[NSMutableArray alloc] init];
    }
    return self;
}

static DownLoadManager *_shareDownLoadManager;
+ (DownLoadManager *)shareDownLoadManager
{
    if(!_shareDownLoadManager)
    {
        _shareDownLoadManager = [[DownLoadManager alloc] init];
    }
    return _shareDownLoadManager;
}

// 添加下载任务
- (void)addDownLoadWithURL:(NSString *)URL andType:(NSInteger)type
{
    // 1.从下载任务队列中按照对应的URL取出下载任务
    DownLoad *dl = [_taskDict objectForKey:URL];
    // 2.判断
    if(!dl)
    {
        NSLog(@"新建下载任务");
        DownLoad *newDl = [[DownLoad alloc] init];
        newDl.downLoadURL = URL;
        newDl.downLoadType = type;
        newDl.delegate = self;
        [newDl downLoadData];
        //将新下载的任务加入到下载队列中
        [_taskDict setObject:newDl forKey:URL];
    }
    else
    {
        NSLog(@"下载任务已经存在,无需重复下载");
    }
}

// 缓存数据
- (void)saveDataWithDataArray:(NSMutableArray *)dataArray andKey:(NSString *)key
{
    NSMutableArray *array = [_dataDict objectForKey:key];
    if(!array)
    {
        [_dataDict setObject:dataArray forKey:key];
        NSLog(@"数据保存成功");
        // 下载成功后发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:key object:nil];
    }
    else
    {
        NSLog(@"数据已经存在,无需再次保存");
    }
}

// 解析数据 根据不同的type值去解析相应的数据
- (void)downLoadFinishWithClass:(id)classObject
{
    DownLoad *downLoad = classObject;
    [_dataArray removeAllObjects];
    [_dataDict removeObjectForKey:downLoad.downLoadURL];
    switch(downLoad.downLoadType)
    {
        case TYPE_NEIGHBOR: //邻居说
        {
            NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:downLoad.data options:NSJSONReadingMutableContainers error:nil];
            NSArray *messageArray = [rootDict objectForKey:@"message"];
            NSLog(@"%@",[rootDict objectForKey:@"status"]);
            if([[rootDict objectForKey:@"status"] isEqualToString:@"400"])
            {
                _status = @"400";
                break;
            }
            for(NSDictionary *dict in messageArray)
            {
                Neighbor *nei = [[Neighbor alloc] init];
                nei.neiPictureArray = [[NSMutableArray alloc] init];
                nei.neiUserArray = [[NSMutableArray alloc] init];
                
                nei.neiCommentNum = [dict objectForKey:@"commentNum"];
                nei.neiContent = [dict objectForKey:@"content"];
                nei.neiForwardNum = [dict objectForKey:@"forwardNum"];
                nei.neiId = [dict objectForKey:@"id"];
                nei.neiIs_Up = [dict objectForKey:@"is_up"];
                nei.neiLookNum = [dict objectForKey:@"lookNum"];
                nei.neiSend_Time = [dict objectForKey:@"send_time"];
                nei.neiShareNum = [dict objectForKey:@"shareNum"];
                nei.neiShare_Id = [dict objectForKey:@"share_id"];
                nei.neiShare_module = [dict objectForKey:@"share_module"];
                nei.neiTitlePic = [dict objectForKey:@"titlePic"];
                nei.neiType = [dict objectForKey:@"type"];
                nei.neiZan = [dict objectForKey:@"zan"];
                NSArray *pictureArray = [dict objectForKey:@"pictures"];
                for(NSString *str in pictureArray)
                {
                    [nei.neiPictureArray addObject:str];
                }
                NSDictionary *userDict = [dict objectForKey:@"user"];
                User *user = [[User alloc] init];
                user.userId = [userDict objectForKey:@"id"];
                user.userName = [userDict objectForKey:@"name"];
                user.userFace = [userDict objectForKey:@"face"];
                [nei.neiUserArray addObject:user];
                [_dataArray addObject:nei];
            }
            // 将数据存储到缓存字典
            [self saveDataWithDataArray:_dataArray andKey:downLoad.downLoadURL];
            break;
        }
        case TYPE_NEIGHBORINFO:     // 邻居说详情
        {
            NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:downLoad.data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *messageDict = [rootDict objectForKey:@"message"];
            NeighobrInfo *neiInfo = [[NeighobrInfo alloc] init];
            NSArray *commentArray = [messageDict objectForKey:@"comment"];
            for(NSDictionary *dict in commentArray)
            {
                NeighobrInfo *neiInfo_array = [[NeighobrInfo alloc]init];
                neiInfo_array.neiInfoContent = [dict objectForKey:@"content"];
                neiInfo_array.neiInfoId = [[dict objectForKey:@"id"] intValue];
                neiInfo_array.neiInfoSend_Time = [dict objectForKey:@"send_time"];
                NSDictionary *dict_user = [dict objectForKey:@"user"];
                User *user = [[User alloc] init];
                user.userFace = [dict_user objectForKey:@"face"];
                user.userId = [dict_user objectForKey:@"id"];
                user.userName = [dict_user objectForKey:@"name"];
                [_neiInfoArray addObject:neiInfo_array];
                [_neiInfoPersonArray addObject:user];
            }
            neiInfo.neiInfoCommentNum = [messageDict objectForKey:@"commentNum"];
            neiInfo.neiInfoContent = [messageDict objectForKey:@"content"];
            neiInfo.neiInfoCurrent = [[messageDict objectForKey:@"current"] integerValue];
            neiInfo.neiInfoForwardNum = [messageDict objectForKey:@"forwardNum"];
            neiInfo.neiInfoId = [[messageDict objectForKey:@"id"] integerValue];
            neiInfo.neiInfoLookNum = [messageDict objectForKey:@"lookNum"];
            neiInfo.neiInfoSend_Time = [messageDict objectForKey:@"send_time"];
            neiInfo.neiInfoShareNum = [messageDict objectForKey:@"shareNum"];
            neiInfo.neiInfoTitlePic = [messageDict objectForKey:@"titlePic"];
            neiInfo.neiInfoTotal = [[messageDict objectForKey:@"total"] integerValue];
            neiInfo.neiInfoZanNum = [messageDict objectForKey:@"zanNum"];
            [_dataArray addObject:neiInfo];
            [self saveDataWithDataArray:_dataArray andKey:downLoad.downLoadURL];
            break;
        }
    }
    // 将此任务从队列中删除
    [_taskDict removeObjectForKey:downLoad.downLoadURL];
}

// 获取小区列表
- (void)getCommunityList
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMUNITY_LIST]];
    request.delegate =self;
    request.tag = 13;
    [request startAsynchronous];
}
// 根据小区id获取门栋号
- (void)getCommunityTentListWithCid:(int)cid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMUNITY_TEN_LIST]];
    request.delegate = self;
    request.tag = 14;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request startAsynchronous];
}
// 根据小区id和门栋id获取单元列表接口
- (void)getCommunityUnityListWithCid:(int)cid andTid:(int)tid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMUNITY_UNITLIST]];
    request.delegate = self;
    request.tag = 15;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",tid] forKey:@"tid"];
    [request startAsynchronous];
}
// 根据单元id获取门号列表接口
- (void)getCommunityRommListWithUid:(int)uid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMUNITY_ROOMLIST]];
    request.delegate = self;
    request.tag = 16;
    [request setPostValue:[NSString stringWithFormat:@"%d",uid] forKey:@"uid"];
    [request startAsynchronous];
}
// 发送注册验证码接口
- (void)sendCaptchaWithPhone:(NSString *)phone
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_USER_SENDCAPTCHA]];
    request.delegate = self;
    request.tag = 17;
    [request setPostValue:phone forKey:@"phone"];
    [request startAsynchronous];
}
// 验证码验证接口
- (void)getCheckCaptchaWithPhone:(NSString *)phone andCid:(int)cid andCode:(NSString *)code
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_USER_CHECKCAPTCHA]];
    request.delegate = self;
    request.tag = 18;
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:code forKey:@"code"];
    [request startAsynchronous];
}
// 邻居说点赞
 - (void)clickZanWithSid:(int)sid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SAY_ZAN]];
    request.delegate = self;
    request.tag = 19;
    [request setPostValue:[NSString stringWithFormat:@"%d",sid] forKey:@"sid"];
    [request startAsynchronous];
}

// 用户登录
- (void)userLoginWithPhone:(NSString *)phone withPassword:(NSString *)password andDid:(NSString *)did andDtype:(int)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_USERLOGIN]];
    request.delegate = self;
    request.tag = 1;
    // 往请求头中添加参数
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:did forKey:@"did"];
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"dtype"];
    [request startAsynchronous];
}
// 修改用户信息
- (void)updatePersonInfoWithfield:(NSString *)field andValue:(NSString *)value
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_UPDATE_PERSONINFO]];
    request.delegate = self;
    request.tag = 24;
    [request setPostValue:field forKey:@"field"];
    [request setPostValue:value forKey:@"value"];
    [request startAsynchronous];
}
// 获取邻居说列表
- (void)getNeighborList:(int)cid andPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_NEIGHBOR]];
    request.delegate = self;
    request.tag = 21;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 获取邻居说详情
- (void)getNeighborInfo:(NSString *)sid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_NEIGHBORINFO_LIST]];
    request.delegate = self;
    request.tag = 40;
    [request setPostValue:sid forKey:@"sid"];
    [request startAsynchronous];
}
// 屏蔽邻居说
- (void)shieldUserWithUid:(int)uid andType:(int)type
{
    ASIFormDataRequest *request;
    if(type == 0)
        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SAY_SHIELDUSER]];
    else if(type == 1)
        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SAY_SHIELDUSER]];
    request.delegate = self;
    request.tag = 22;
    [request setPostValue:[NSString stringWithFormat:@"%d",uid] forKey:@"uid"];
    [request startAsynchronous];
}
// 活动列表
- (void)getActivityListWithCid:(NSString *)cid andPage:(NSString *)pageNo
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ACTIVITY_LIST]];
    request.delegate = self;
    request.tag = 3;
    // 往请求头中添加参数
    [request setPostValue:cid forKey:@"cid"];
    [request setPostValue:pageNo forKey:@"page"];
    [request startAsynchronous];
    
}
// 活动详情
- (void)getActivityDetailWithAid:(NSString *)aid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ACTIVITY_DETAIL]];
    request.delegate = self;
    request.tag = 4;
    // 往请求头中添加参数
    [request setPostValue:aid forKey:@"aid"];
    [request startAsynchronous];
}
// 优惠券列表
- (void)getDiscountListWithCid:(int)cid andPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_DISCOUNT_LIST]];
    request.delegate = self;
    request.tag = 5;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 优惠券详情
- (void)getDiscountDetailWithCid:(int)cid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_DISCOUNT_DETAIL]];
    request.delegate = self;
    request.tag = 6;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request startAsynchronous];
}
// 物业缴费
- (void)getRealPayListWithCid:(int)cid andPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REAL_PAY_LIST]];
    request.delegate = self;
    request.tag = 7;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}

// 服务列表
- (void)getServerListWithCid:(int)cid andRecid:(int)recid andPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERVER_LIST]];
    request.delegate = self;
    request.tag = 8;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",recid] forKey:@"recid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 服务详情
- (void)getServerDetailWithsid:(int)sid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERVER_DETAIL]];
    request.delegate = self;
    request.tag = 9;
    [request setPostValue:[NSString stringWithFormat:@"%d",sid] forKey:@"sid"];
    [request startAsynchronous];
}
// 呼叫服务
- (void)sendServerWithSid:(int)sid andDtime:(NSString *)dtime andContent:(NSString *)content andRid:(int)rid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERVER_CALL]];
    request.delegate = self;
    request.tag = 10;
    [request setPostValue:[NSString stringWithFormat:@"%d",sid] forKey:@"sid"];
    [request setPostValue:[NSString stringWithFormat:@"%@",dtime] forKey:@"dtime"];
    [request setPostValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    [request setPostValue:[NSString stringWithFormat:@"%d",rid] forKey:@"rid"];
    [request startAsynchronous];
}
// 获取小区服务时间
- (void)getCommuityServerTimeWithCid:(int)cid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERVER_TIME]];
    request.tag = 11;
    request.delegate = self;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request startAsynchronous];
}
// 获取服务系列价格
- (void)getServerPriceListWithSid:(NSString *)sid andType:(NSString *)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERVER_SERIES_PRICE]];
    request.delegate = self;
    request.tag = 12;
    price_type = type;
    [request setPostValue:sid forKey:@"sid"];
    [request setPostValue:type forKey:@"type"];
    [request startAsynchronous];
}
// 商户版
// 商户物业订单管理列表接口
- (void)getOrderServerListWithCid:(int)cid andMid:(int)mid andPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ORDERSERVER_LIST]];
    request.delegate = self;
    request.tag = 20;
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",mid] forKey:@"mid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 订单详情
- (void)getOrderServerInfoWithOsid:(int)osid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ORDERSERVER_INFO_LIST]];
    request.delegate = self;
    request.tag = 23;
    [request setPostValue:[NSString stringWithFormat:@"%d",osid] forKey:@"oid"];
    [request startAsynchronous];
}
// 获取我的订单列表（服务）接口
- (void)getMyOrderServeListWithPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MYORDERSERVER_LIST]];
    request.delegate = self;
    request.tag = 25;
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 获取我的优惠券列表
- (void)getMyCouponListWithPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COUPON_LIST]];
    request.delegate = self;
    request.tag = 26;
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 获取我的积分详情
 - (void)getMyPointInfo
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MYPOINTINFO]];
    request.delegate = self;
    request.tag = 27;
    [request startAsynchronous];
}
// 商品型订单下单
- (void)getServerBookWithSid:(int)sid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERVER_BOOK]];
    request.delegate = self;
    request.tag = 28;
    [request setPostValue:[NSString stringWithFormat:@"%d",sid] forKey:@"sid"];
    [request startAsynchronous];
}

// 发送信息
- (void)sendMessageWithToId:(NSString *)toId andContent:(id)content andType:(int)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SENDMESSAGE]];
    request.delegate = self;
    request.tag = 29;
    [request setPostValue:toId forKey:@"to_id"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [request startAsynchronous];
}
// 获取消息列表接口
- (void)getTalkList
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MESSAGE_TALKLIST]];
    request.delegate = self;
    request.tag = 30;
    [request startAsynchronous];
}
// 加载历史消息
- (void)getMessageRepastWithFrom_Id:(NSString *)from_id
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REPAST_MESSAGE]];
    request.delegate = self;
    request.tag = 31;
    [request setPostValue:from_id forKey:@"from_id"];
    [request startAsynchronous];
}
// 创建群组
- (void)createGroupMessage:(NSArray *)marray
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CREATE_GROUPMESSAGE]];
    request.tag = 32;
    request.delegate = self;
    NSMutableString *MID = [[NSMutableString alloc] init];
    for(int i = 0; i < marray.count; i ++)
    {
        NSString *midstr = [NSString stringWithFormat:@"%@,",[marray objectAtIndex:i]];
        [MID appendString:midstr];
    }
    NSRange range = NSMakeRange(0, MID.length-1);
    NSString *mids = [[NSString stringWithString:MID] substringWithRange:range];
    NSLog(@"%@/%@",URL_CREATE_GROUPMESSAGE,mids);
    [request setPostValue:mids forKey:@"mid"];
    [request startAsynchronous];
}
// 退出群组
- (void)quitGroupMessage:(NSString *)gid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_QUIT_GROUPMESSAGE]];
    request.tag = 33;
    request.delegate = self;
    [request setPostValue:gid forKey:@"gid"];
    [request startAsynchronous];
}
// 接收新消息
- (void)accpetMessageWithFrom_Id:(NSString *)from_id
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] init];
    request.tag = 34;
    request.delegate = self;
    [request setPostValue:from_id forKey:@"from_id"];
    [request startAsynchronous];
}
// 获取通讯录
- (void)getAddressBookWithCid:(NSString *)cid andGid:(NSString *)gid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_USER_LIST]];
    request.tag = 35;
    request.delegate = self;
    [request setPostValue:cid forKey:@"cid"];
    [request setPostValue:gid forKey:@"gid"];
    [request startAsynchronous];
}
// 发送聊天消息 （群聊）
- (void)sendMessageWithGid:(NSString *)gid andContent:(id)content andType:(int)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SENDMESSAGE_MORE]];
    request.tag = 36;
    request.delegate = self;
    [request setPostValue:gid forKey:@"gid"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [request startAsynchronous];
}
// 查看群信息
- (void)selectGroupInfoWithGid:(NSString *)gid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_LOOK_GROUPINFO]];
    request.delegate = self;
    request.tag = 37;
    [request setPostValue:gid forKey:@"gid"];
    [request startAsynchronous];
}
// 获取历史消息（群聊）
- (void)getGroupMessageWithGid:(NSString *)gid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REPAST_MESSAGE_GROUP]];
    request.delegate = self;
    request.tag = 38;
    [request setPostValue:gid forKey:@"gid"];
    [request startAsynchronous];
}
// 发布评论
- (void)sendCommentWithMid:(NSString *)mid andPid:(NSString *)pid andContent:(NSString *)content
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMENT_SEND]];
    request.delegate = self;
    request.tag = 39;
    [request setPostValue:mid forKey:@"mid"];
    [request setPostValue:pid forKey:@"pid"];
    [request setPostValue:content forKey:@"content"];
    [request startAsynchronous];
}

// 发布邻居说
- (void)sendNeighbor:(NSString *)content andPic:(NSString *)pic andCid:(int)cid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_NEIGHBOR_SEND_SPEAK]];
    request.delegate = self;
    request.tag = 2;
    // 往请求头中添加参数
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:pic forKey:@"pic"];
    [request startAsynchronous];
}

// 发送文件
- (void)sendMessageWithId:(NSString *)to_id andObject:(id)objects andType:(int)type andFrom_Id:(NSString *)from_id andContentType:(int)speakType
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMON_UPLOAD]];
    request.delegate = self;
    request.tag = 39;
    if(speakType == 0)
    {
        [request setPostValue:to_id forKey:@"to_id"];
    }
    else
    {
        [request setPostValue:to_id forKey:@"group_id"];
    }
    [request setPostValue:from_id forKey:@"from_id"];
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    if([objects isKindOfClass:[NSURL class]])
    {
        [request setFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"] forKey:@"file"];
    }
    else
    {
        [request setData:UIImageJPEGRepresentation(objects, 0.1) withFileName:@"001.jpg" andContentType:@"image/jpg" forKey:@"file"];
    }
    [request startAsynchronous];
}
// 获取优惠券
- (void)getCouponWithCid:(NSString *)cid andNum:(int)num andOff:(int)off andUid:(NSString *)uid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COUPON]];
    request.tag = 41;
    request.delegate = self;
    [request setPostValue:cid forKey:@"cid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",num] forKey:@"num"];
    [request setPostValue:[NSString stringWithFormat:@"%d",off] forKey:@"off"];
    [request setPostValue:uid forKey:@"uid"];
    [request startAsynchronous];
}
// 参加活动
- (void)joinActivityWithAid:(NSString *)aid andName:(NSString *)name andPhone:(NSString *)phone andRid:(NSString *)rid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_JOINACTIVITY]];
    request.tag = 42;
    request.delegate = self;
    [request setPostValue:aid forKey:@"aid"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:rid forKey:@"rid"];
    [request startAsynchronous];
}
// 我的房产
- (void)getMyRooms
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MYROOMS]];
    request.tag = 43;
    request.delegate = self;
    [request startAsynchronous];
}
// 物业缴费优惠套餐
- (void)getRealPayWith:(int)rid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REAL_PAY]];
    request.tag = 44;
    request.delegate = self;
    [request setPostValue:[NSString stringWithFormat:@"%d",rid] forKey:@"rid"];
    [request startAsynchronous];
}
// 物业缴费立即支付接口
- (void)getRealPaySubmitWithRid:(NSString *)rid andPrice:(NSString *)price andStart:(NSString *)start andEnd:(NSString *)end
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REAL_PAY_SUBMIT]];
    request.tag = 45;
    request.delegate = self;
    [request setPostValue:rid forKey:@"rid"];
    [request setPostValue:price forKey:@"price"];
    [request setPostValue:start forKey:@"start"];
    [request setPostValue:end forKey:@"end"];
    [request startAsynchronous];
}
// 查看用户信息
- (void)getSayUserInfoWithUid:(NSString *)uid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_NEIGHOBR_INFO]];
    request.tag = 46;
    request.delegate = self;
    [request setPostValue:uid forKey:@"uid"];
    [request startAsynchronous];
}
// 收货地址列表
- (void)getAddressListWith
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ADDRESS_LIST]];
    request.tag = 47;
    request.delegate = self;
    [request startAsynchronous];
}

// 增加收货地址
- (void)addAddressWithAction:(NSString *)action andCid:(NSString *)cid andRid:(NSString *)rid andName:(NSString *)name andPhone:(NSString *)phone
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ADDRESS_ADD]];
    request.tag = 48;
    request.delegate = self;
    [request setPostValue:action forKey:@"action"];
    [request setPostValue:cid forKey:@"cid"];
    [request setPostValue:rid forKey:@"rid"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:phone forKey:@"phone"];
    [request startAsynchronous];
}
// 获取我的优惠券列表
- (void)getMyCouponList
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MYCOUPONLIST]];
    request.tag = 49;
    request.delegate = self;
    [request startAsynchronous];
}
// 提交订单接口列表
- (void)submitOrderWithOid:(NSString *)oid andType:(NSString *)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SUBMITORDER]];
    request.tag = 50;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request setPostValue:type forKey:@"type"];
    [request startAsynchronous];
    
}

// 添加群组成员
- (void)addUserWithGid:(NSString *)gid andUids:(NSString *)uid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_GROUP_ADDUSER]];
    request.tag = 51;
    request.delegate = self;
    [request setPostValue:gid forKey:@"gid"];
    [request setPostValue:uid forKey:@"uids"];
    [request startAsynchronous];
}
// 获取用户资料
- (void)getMyUserInfo
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_PERSONINFO]];
    request.tag =  52;
    request.delegate = self;
    [request startAsynchronous];
}
// 获取订单详情接口
- (void)getOrderServiceWithOid:(NSString *)oid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ORDERSERVER_INFO_LIST]];
    request.tag = 53;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request startAsynchronous];
}
// 获取隐私列表
- (void)getShieldListWithType:(int)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SHIELDLIST]];
    request.tag = 54;
    request.delegate = self;
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [request startAsynchronous];
}
// 解除屏蔽接口
- (void)delShieldWithUid:(NSString *)uid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_DELSHIELD]];
    request.tag = 55;
    request.delegate = self;
    [request setPostValue:uid forKey:@"uid"];
    [request startAsynchronous];
}
// 修改密码接口
- (void)editPasswordWithPassword:(NSString *)password andNewPassword:(NSString *)newPassword andRePassword:(NSString *)rePassword
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHANGEPWD]];
    request.tag = 56;
    request.delegate = self;
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:newPassword forKey:@"newPassword"];
    [request setPostValue:rePassword forKey:@"rePassword"];
    [request startAsynchronous];
}

// 修改 和 下订单
- (void)EditOrSendOrderService:(NSString *)oid andInfo:(NSString *)info
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_EDIT_ORDER_EVENT]];
    request.tag = 57;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request setPostValue:info forKey:@"info"];
    [request startAsynchronous];
}
// 抓发 （单聊）
- (void)forwardNeighborToMessage:(NSString *)mid andPid:(NSString *)pid andTo_Id:(NSString *)to_id
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_FORWORD]];
    request.tag = 58;
    request.delegate = self;
    [request setPostValue:mid forKey:@"mid"];
    [request setPostValue:pid forKey:@"pid"];
    [request setPostValue:to_id forKey:@"to_id"];
    [request startAsynchronous];
}
// 获取邻居说列表
- (void)getMySayList:(NSString *)cid andUid:(NSString *)uid andPage:(int)page
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_NEIGHBOR_OTHER_SPEAK]];
    request.tag = 59;
    request.delegate = self;
    [request setPostValue:cid forKey:@"cid"];
    [request setPostValue:uid forKey:@"uid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [request startAsynchronous];
}
// 取消订单jiekou
- (void)orderServerCancelOrdrWithOid:(NSString *)oid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CANCELORDER_SERVER]];
    request.tag = 60;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request startAsynchronous];
}

// 邻居圈发送文件接口
- (void)uploadImage:(UIImage *)image andType:(int)type
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_COMMON_UPLOAD]];
    request.tag = 61;
    request.delegate = self;
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [request setData:UIImageJPEGRepresentation(image, 0.5) withFileName:@"001.jpg" andContentType:@"image/jpg" forKey:@"file"];
    [request startAsynchronous];
}
// 填写订单信息接口
- (void)saveOrderEventWithOid:(NSString *)oid andInfo:(NSString *)info
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SAVEORDEREVENT]];
    request.tag = 2;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request setPostValue:info forKey:@"info"];
    [request startAsynchronous];
}
// 业主确认订单
- (void)conFirmOrderWithOid:(NSString *)oid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CONFIRM_ORDER]];
    request.tag = 2;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request startAsynchronous];
}
// 取消订单接口
- (void)cancleOrderWithOid:(NSString *)oid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CANCELORDER_SERVER]];
    request.tag = 2;
    request.delegate = self;
    [request setPostValue:oid forKey:@"oid"];
    [request startAsynchronous];
}
// 置顶消息列表中指定的一条
- (void)toTopMessageWithLid:(NSString *)lid andType:(int)type
{
    ASIFormDataRequest *request;
    if(type == 0)
        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MESSAGE_TOTOP]];
    else if(type == 1)
        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MESSAGE_TODELETE]];
    request.tag = 2; // 置顶
    request.delegate = self;
    [request setPostValue:lid forKey:@"lid"];
    [request startAsynchronous];
}
// 屏蔽消息列表
- (void)shieldUserWithUid:(int)uid andType:(int)type andStyle:(int)style
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_MESSAGE_DELSHIELD]];
    request.delegate = self;
    request.tag = 2;
    [request setPostValue:[NSString stringWithFormat:@"%d",uid] forKey:@"uid"];
    [request setPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [request setPostValue:[NSString stringWithFormat:@"%d",style] forKey:@"style"];
    [request startAsynchronous];
}
// 优惠券排序和筛选逻辑
- (void)couponSortWithOrder:(NSString *)order andType:(int)kind andCid:(int)cid
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_DISCOUNT_LIST]];
    request.delegate = self;
    request.tag = 5;
    if(kind == 0)
        [request setPostValue:order forKey:@"order"];
    else if(kind == 1)
        [request setPostValue:order forKey:@"type"];
    else if(kind == 2)
        [request setPostValue:order forKey:@"keyword"];
    [request setPostValue:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
    [request startAsynchronous];
}
// 修改群名称
- (void)groupNameUpdate:(NSString *)gid andName:(NSString *)gname
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_GROUP_NAME]];
    request.tag = 2;
    request.delegate = self;
    [request setPostValue:gid forKey:@"gid"];
    [request setPostValue:gname forKey:@"name"];
    [request startAsynchronous];
}
- (void)userForgetPwd:(NSString *)phone
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_FORGETPWD]];
    request.delegate = self;
    request.tag = 2;
    [request setPostValue:phone forKey:@"phone"];
    [request startAsynchronous];
}

// 成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // 清空
    [_commentArray removeAllObjects];
    [_userArray removeAllObjects];
    
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if(rootDict.count == 0)
    {
        return;
    }
    //NSString *str = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSDictionary *messageDict = [rootDict objectForKey:@"message"];
    NSArray *messageArray = [rootDict objectForKey:@"message"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
    {
        switch(request.tag)
        {
            case 1:
            {
                User *user = [[User alloc] init];
                user.userPhone = [messageDict objectForKey:@"phone"];
                user.userPassword = [messageDict objectForKey:@"password"];
                user.userNickName = [messageDict objectForKey:@"nickname"];
                user.userFace = [messageDict objectForKey:@"face"];
                user.userCommunity_Type = [messageDict objectForKey:@"community_type"];
                user.userLoginType = [messageDict objectForKey:@"type"];
                user.userId = [messageDict objectForKey:@"id"];
                user.userCommunity_Id = [messageDict objectForKey:@"community_id"];
                user.userLeave = [messageDict objectForKey:@"leave"];
                _myUserId = user.userId;
                _loginType = user.userLoginType;
                _myUserFace = user.userFace;
                _communityId = [user.userCommunity_Id intValue];
                _currentLeave = [user.userLeave intValue];
                _status = @"200";
                
                _loginSuccessBlcok(user);
                break;
            }
            case 2:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 发布邻居说成功
                    _sendMessageSuccess ();
                }
                break;
            }
            case 3:
            {
                for(NSDictionary *dict in messageDict)
                {
                    Activity *acti = [[Activity alloc] init];
                    acti.actiBuilderArray = [[NSMutableArray alloc] init];
                    acti.actiContent = [dict objectForKey:@"content"];
                    acti.actiId = [dict objectForKey:@"id"];
                    acti.actiJoinNum = [dict objectForKey:@"joinNum"];
                    acti.actiJoin = [dict objectForKey:@"join"];
                    acti.actiSend_Time = [dict objectForKey:@"send_time"];
                    acti.actiShareNum = [dict objectForKey:@"shareNum"];
                    acti.actiTheMe = [dict objectForKey:@"theme"];
                    acti.actiTitlePic = [dict objectForKey:@"titlePic"];
                    acti.actiLookNum = [dict objectForKey:@"lookNum"];
                    
                    User *user = [[User alloc] init];
                    NSDictionary *userDict = [dict objectForKey:@"builder"];
                    user.userId = [userDict objectForKey:@"id"];
                    user.userName = [userDict objectForKey:@"name"];
                    user.userFace = [userDict objectForKey:@"face"];
                    [acti.actiBuilderArray addObject:user];
                    [dataArray addObject:acti];
                }
                _activityBlock (dataArray);

                break;
            }
            case 4:
            {
                ActivityInfo *actiInfo = [[ActivityInfo alloc] init];
                actiInfo.actiInfoAddtions = [[NSMutableArray alloc] init];
                actiInfo.actiInfoComments = [[NSMutableArray alloc] init];
                actiInfo.actiInfoPictures = [[NSMutableArray alloc] init];
                actiInfo.actiInfoUsers = [[NSMutableArray alloc] init];
                actiInfo.actiInfoContent = [messageDict objectForKey:@"content"];
                actiInfo.actiInfoCurrent = [messageDict objectForKey:@"current"];
                actiInfo.actiInfoEnd = [messageDict objectForKey:@"end"];
                actiInfo.actiInfoForwordNum = [messageDict objectForKey:@"forwordNum"];
                actiInfo.actiInfoId = [messageDict objectForKey:@"id"];
                actiInfo.actiInfoJoin = [messageDict objectForKey:@"join"];
                actiInfo.actiInfoJoinNum = [messageDict objectForKey:@"joinNum"];
                actiInfo.actiInfoLookNum = [messageDict objectForKey:@"lookNum"];
                actiInfo.actiInfoSend_Time = [messageDict objectForKey:@"send_time"];
                actiInfo.actiInfoShareNum = [messageDict objectForKey:@"shareNum"];
                actiInfo.actiInfoStart = [messageDict objectForKey:@"start"];
                actiInfo.actiInfoTheMe = [messageDict objectForKey:@"theme"];
                actiInfo.actiInfoTitlePic = [messageDict objectForKey:@"titlePic"];
                actiInfo.actiInfoTotal = [messageDict objectForKey:@"total"];
                NSArray *addtions = [messageDict objectForKey:@"addtions"];
                for(NSDictionary *dict in addtions)
                {
                    Comment *comment = [[Comment alloc] init];
                    comment.commContent = [dict objectForKey:@"content"];
                    comment.commSendTime = [dict objectForKey:@"theme"];    // 代替附加说明
                    [actiInfo.actiInfoAddtions addObject:comment];
                }
                NSDictionary *userDict = [messageDict objectForKey:@"builder"];
                actiInfo.actiInfoUserFace = [userDict objectForKey:@"face"];
                actiInfo.actiInfoUserId = [userDict objectForKey:@"id"];
                actiInfo.actiInfoUserName = [userDict objectForKey:@"name"];
                
                NSArray *comments = [messageDict objectForKey:@"comment"];
                for(NSDictionary *dict in comments)
                {
                    Comment *comm = [[Comment alloc] init];
                    comm.commContent = [dict objectForKey:@"content"];
                    comm.commSendTime = [dict objectForKey:@"send_time"];
                    [actiInfo.actiInfoComments addObject:comm];
                
                    User *user = [[User alloc] init];
                    NSDictionary *uDict = [dict objectForKey:@"user"];
                    user.userFace = [uDict objectForKey:@"face"];
                    user.userName = [uDict objectForKey:@"name"];
                    user.userId = [uDict objectForKey:@"id"];
                    [actiInfo.actiInfoUsers addObject:user];
                
                }
                NSArray *pictures = [messageDict objectForKey:@"pictures"];
                for(NSString *str in pictures)
                {
                    [actiInfo.actiInfoPictures addObject:str];
                }
                _activityDetailBlock (actiInfo);
                break;
            }
            case 5: // 优惠券
            {
                for(NSDictionary *dict in messageArray)
                {
                    Discount *discount = [[Discount alloc] init];
                    discount.disEnd = [dict objectForKey:@"end"];
                    discount.disGot = [dict objectForKey:@"got"];
                    discount.disId = [dict objectForKey:@"id"];
                    discount.disName = [dict objectForKey:@"name"];
                    discount.disPrice = [dict objectForKey:@"price"];
                    discount.disStart = [dict objectForKey:@"start"];
                    discount.disTitlePic = [dict objectForKey:@"titlePic"];
                    [dataArray addObject:discount];
                }
                _discountBlock(dataArray);

                break;
            }
            case 6:     // 优惠券详情接口
            {
                Coupon *cou = [[Coupon alloc] init];
                cou.couComments = [[NSMutableArray alloc] init];
                cou.couPictures = [[NSMutableArray alloc] init];
                cou.couUsers = [[NSMutableArray alloc] init];
                NSArray *comments = [messageDict objectForKey:@"comment"];
                for(NSDictionary *dict in comments)
                {
                    Comment *comment = [[Comment alloc] init];
                    comment.commContent = [dict objectForKey:@"content"];
                    comment.commSendTime = [dict objectForKey:@"send_time"];
                    NSDictionary *userDict = [dict objectForKey:@"user"];
                    User *user = [[User alloc] init];
                    user.userFace = [userDict objectForKey:@"face"];
                    user.userId = [userDict objectForKey:@"id"];
                    user.userName = [userDict objectForKey:@"name"];
                    [cou.couComments addObject:comment];
                    [cou.couUsers addObject:user];
                }
                NSArray *pictures = [messageDict objectForKey:@"pictures"];
                for(NSString *picture in pictures)
                {
                    [cou.couPictures addObject:picture];
                }
                cou.couCommentNum = [messageDict objectForKey:@"commentNum"];
                cou.couDiscription = [messageDict objectForKey:@"discription"];
                cou.couEnd = [messageDict objectForKey:@"end"];
                cou.couFace_Value = [messageDict objectForKey:@"face_value"];
                cou.couForwardNum = [messageDict objectForKey:@"forwardNum"];
                cou.couGetNum = [messageDict objectForKey:@"getNum"];
                cou.couId = [messageDict objectForKey:@"id"];
                cou.couLogin_Face = [messageDict objectForKey:@"login_face"];
                cou.couMerchant = [messageDict objectForKey:@"merchant"];
                cou.couMerchant_Pic  = [messageDict objectForKey:@"merchant_pic"];
                cou.couName = [messageDict objectForKey:@"name"];
                cou.couPrice = [messageDict objectForKey:@"price"];
                cou.couServices =[messageDict objectForKey:@"services"];
                cou.couShareNum = [messageDict objectForKey:@"shareNum"];
                cou.couStart = [messageDict objectForKey:@"start"];
                cou.couTitlePic = [messageDict objectForKey:@"titlePic"];
                _couponDetailBlock (cou);
                break;
            }
            case 7:
            {
                for(NSDictionary *dict in messageArray)
                {
                    RealPay *realPay = [[RealPay alloc] init];
                    realPay.realId = [dict objectForKey:@"id"];
                    realPay.realName = [dict objectForKey:@"name"];
                    realPay.realUrge = [dict objectForKey:@"urge"];
                    realPay.realCurrent = [[dict objectForKey:@"current"] intValue];
                    realPay.realTotal = [[dict objectForKey:@"total"] intValue];
                    [dataArray addObject:realPay];
                }
                _realPayListBlock(dataArray);

                break;
            }
            case 8:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Server *server = [[Server alloc] init];
                    server.serId = [dict objectForKey:@"id"];
                    server.serName = [dict objectForKey:@"name"];
                    server.serOrder_type = [dict objectForKey:@"order_type"];
                    server.serTitlePic = [dict objectForKey:@"titlePic"];
                    [dataArray addObject:server];
                }
                _serverListBlock (dataArray);
                break;
            }
            case 9:
            {
                Server *server = [[Server alloc] init];
                server.serPicturesArray = [[NSMutableArray alloc] init];
                server.serId = [messageDict objectForKey:@"id"];
                server.serCommentNum = [messageDict objectForKey:@"commentNum"];
                
                server.serDescription = [messageDict objectForKey:@"description"];
                server.serName = [messageDict objectForKey:@"name"];
                server.serOrder_type =[messageDict objectForKey:@"order_type"];
                server.serPrice = [messageDict objectForKey:@"price"];
                server.serPrice_type = [messageDict objectForKey:@"price_type"];
                NSDictionary *dict = [messageDict objectForKey:@"merchant"];
                server.serMerId = [dict objectForKey:@"id"];
                server.serMerName = [dict objectForKey:@"name"];
                NSArray *pictures = [messageDict objectForKey:@"pictures"];
                for(int i = 0; i < pictures.count; i ++)
                {
                    [server.serPicturesArray addObject:[pictures objectAtIndex:i]];
                }
                [dataArray addObject:server];
                _serverDetailBlock (dataArray);
                break;
            }
            case 10:
            {
                Server *server = [[Server alloc] init];
                server.serMessage = [rootDict objectForKey:@"message"];
                server.serOrder_Code = [rootDict objectForKey:@"order_code"];
                server.serOrder_Id = [rootDict objectForKey:@"order_id"];
                server.serStatus = [rootDict objectForKey:@"status"];
                _serverOrder_Code = server.serOrder_Code;
                _status = @"200";
                _sendServerSuccessBlock();
                break;
            }
            case 11:
            {
                NSString *end = [messageDict objectForKey:@"end"];
                end = [end substringToIndex:5];
                NSString *start = [messageDict objectForKey:@"start"];
                start = [start substringToIndex:5];
                _serverTime = [NSString stringWithFormat:@"%@ - %@",start,end];
                _commuityServerTimeBlock();
                break;
            }
            case 12:
            {
                if([price_type isEqualToString:@"2"])
                {
                    for(NSDictionary *dict in messageArray)
                    {
                        Server *server = [[Server alloc] init];
                        server.serDescription = [dict objectForKey:@"discription"];
                        server.serId = [dict objectForKey:@"id"];
                        server.serName = [dict objectForKey:@"name"];
                        server.serPrice = [dict objectForKey:@"price"];
                        [dataArray addObject:server];
                    }
                    _serverPriceListBlock (dataArray);
                }
                else    // 大类
                {
                    
                    for(NSDictionary *dict in messageArray)
                    {
                        Server *server = [[Server alloc] init];
                        server.serEvents = [[NSMutableArray alloc] init];
                        server.serPrice_type = [dict objectForKey:@"type"];
                        NSArray *array = [dict objectForKey:@"event"];
                        for(NSDictionary *eventDict in array)
                        {
                            Server *ser = [[Server alloc] init];
                            ser.serDescription = [eventDict objectForKey:@"discription"];
                            ser.serId = [eventDict objectForKey:@"id"];
                            ser.serName = [eventDict objectForKey:@"name"];
                            ser.serPrice = [eventDict objectForKey:@"price"];
                            [server.serEvents addObject:ser];
                        }
                        [dataArray addObject:server];
                    }
                    _serverPriceListBlock (dataArray);
                }

                break;
            }
            case 13:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Community *comm = [[Community alloc] init];
                    comm.commId = [dict objectForKey:@"id"];
                    comm.commName = [dict objectForKey:@"name"];
                    comm.commPic = [dict objectForKey:@"pic"];
                    [dataArray addObject:comm];
                }
                _communityListBlock (dataArray);

                break;
            }
            case 14:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Community *comm = [[Community alloc] init];
                    comm.commId = [dict objectForKey:@"id"];
                    comm.commName = [dict objectForKey:@"name"];
                    [dataArray addObject:comm];
                }
                _communityTentListBlock(dataArray);
                break;
            }
            case 15:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Community *comm = [[Community alloc] init];
                    comm.commId = [dict objectForKey:@"id"];
                    comm.commName = [dict objectForKey:@"name"];
                    [dataArray addObject:comm];
                }
                _communtityuntityListBlock(dataArray);
                break;
            }
            case 16:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Community *comm = [[Community alloc] init];
                    comm.commId = [dict objectForKey:@"id"];
                    comm.commName = [dict objectForKey:@"name"];
                    comm.commLong_Name =[dict objectForKey:@"long_name"];
                    [dataArray addObject:comm];
                }
                _communityRoomListBlock (dataArray);
                break;
            }
            case 17:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 获取成功
                    _sendMessageSuccess ();
                }
                break;
            }
            case 18:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 获取成功
                    _sendMessageSuccess ();
                }
                break;

            }
            case 19:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    int zanNum = [[rootDict objectForKey:@"zan_num"] intValue];
                    _clickZanSuccessBlock(zanNum);
                }
                break;
            }
            case 20:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Order *order = [[Order alloc] init];
                    order.orderUid = [dict objectForKey:@"uid"];
                    order.orderUface = [dict objectForKey:@"uface"];
                    order.orderState = [dict objectForKey:@"state"];
                    order.orderOsid = [dict objectForKey:@"osid"];
                    order.orderName = [dict objectForKey:@"name"];
                    order.orderCode = [dict objectForKey:@"code"];
                    order.orderAuthenticate = [[dict objectForKey:@"authenticate"] intValue];
                    [dataArray addObject:order];
                }
                    _orderServerListBlock (dataArray);

                break;
            }
            case 21:
            {
                for(NSDictionary *dict in [rootDict objectForKey:@"advers"])
                {
                    [_advers addObject:[dict objectForKey:@"pic"]];
                }
                
                for(NSDictionary *dict in messageArray)
                {
                    Neighbor *nei = [[Neighbor alloc] init];
                    nei.neiPictureArray = [[NSMutableArray alloc] init];
                    nei.neiUserArray = [[NSMutableArray alloc] init];
                    
                    nei.neiCommentNum = [dict objectForKey:@"commentNum"];
                    nei.neiContent = [dict objectForKey:@"content"];
                    nei.neiForwardNum = [dict objectForKey:@"forwardNum"];
                    nei.neiId = [dict objectForKey:@"id"];
                    nei.neiIs_Up = [dict objectForKey:@"is_up"];
                    nei.neiSend_Time = [dict objectForKey:@"send_time"];
                    nei.neiShareNum = [dict objectForKey:@"shareNum"];
                    nei.neiShare_Id = [dict objectForKey:@"share_id"];
                    nei.neiShare_module = [dict objectForKey:@"share_module"];
                    nei.neiTitlePic = [dict objectForKey:@"titlePic"];
                    nei.neiType = [dict objectForKey:@"type"];
                    nei.neiZanNum =[dict objectForKey:@"zanNum"];
                    nei.neiZan = [dict objectForKey:@"zan"];
                    NSArray *pictureArray = [dict objectForKey:@"pictures"];
                    for(NSString *str in pictureArray)
                    {
                        [nei.neiPictureArray addObject:str];
                    }
                    NSDictionary *userDict = [dict objectForKey:@"user"];
                    User *user = [[User alloc] init];
                    user.userId = [userDict objectForKey:@"id"];
                    user.userName = [userDict objectForKey:@"name"];
                    user.userFace = [userDict objectForKey:@"face"];
                    [nei.neiUserArray addObject:user];
                    [dataArray addObject:nei];
                }
                _neighborListBlock (dataArray);
                break;
            }
            case 22:  // 屏蔽邻居说
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    _shieldUserSuccessBlock();
                }
                break;
            }
            case 23:    // 订单详情
            {
                OrderInfo *oinfo = [[OrderInfo alloc] init];
                oinfo.oinfoId = [messageDict objectForKey:@"id"];
                oinfo.oinfoCode = [messageDict objectForKey:@"code"];
                oinfo.oinfoState = [messageDict objectForKey:@"state"];
                oinfo.oinfoTotal = [messageDict objectForKeyedSubscript:@"total"];
                oinfo.oinfoOrder_Time = [messageDict objectForKey:@"order_time"];
                NSDictionary *serverDict = [messageDict objectForKey:@"service"];
                oinfo.seName = [serverDict objectForKey:@"name"];
                oinfo.seTitlePic = [serverDict objectForKey:@"titlePic"];
                NSDictionary *reDict = [messageDict objectForKey:@"reservation"];
                if(reDict.count > 0)
                {
                    oinfo.reRoom = [reDict objectForKey:@"room"];
                    oinfo.rePhone = [reDict objectForKey:@"phone"];
                    oinfo.reName = [reDict objectForKey:@"name"];
                    oinfo.reDate_time = [reDict objectForKey:@"date_time"];
                }
                NSDictionary *addDict = [messageDict objectForKey:@"address"];
                if(addDict.count > 0)
                {
                    oinfo.addAddress = [addDict objectForKey:@"address"];
                    oinfo.addContact = [addDict objectForKey:@"contact"];
                    oinfo.addName = [addDict objectForKey:@"name"];
                }
                NSDictionary *serDict = [messageDict objectForKey:@"service"];
                if(serDict.count > 0)
                {
                    oinfo.seType = [serDict objectForKey:@"type"];
                    oinfo.seId = [serDict objectForKey:@"id"];
                    oinfo.seName = [serDict objectForKey:@"name"];
                    oinfo.seTitlePic = [serDict objectForKey:@"titlePic"];
                    oinfo.sePrice_Type = [serDict objectForKey:@"price_type"];
                }
                [dataArray addObject:oinfo];
                _orderServerInfoBlock (dataArray);
                break;
            }
            case 24:    // 修改用户信息
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    _updatePersonInfoSuccessBlock();
                }
                break;
            }
            case 25:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Order *order = [[Order alloc] init];
                    order.orderUid = [dict objectForKey:@"id"];
                    order.orderCode = [dict objectForKey:@"code"];
                    order.orderState = [dict objectForKey:@"state"];
                    order.orderName = [dict objectForKey:@"service_name"];
                    order.orderMoney = [dict objectForKey:@"money"];;
                    NSDictionary *buyDict = [dict objectForKey:@"merchant"];
                    order.buyId = [buyDict objectForKey:@"id"];
                    order.buyLogo = [buyDict objectForKey:@"logo"];
                    order.buyName = [buyDict objectForKey:@"name"];
                    [dataArray addObject:order];
                }
                _myOrderServerListBlock (dataArray);
                break;
            }
            case 26:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Coupon *cou = [[Coupon alloc] init];
                    cou.couType = [dict objectForKey:@"type"];
                    cou.couName = [dict objectForKey:@"name"];
                    cou.couCode = [dict objectForKey:@"code"];
                    cou.couValue = [dict objectForKey:@"value"];
                    cou.couLeft_Value = [dict objectForKey:@"left_value"];
                    cou.couEnd = [dict objectForKey:@"end"];
                    cou.couState = [dict objectForKey:@"state"];
                    [dataArray addObject:cou];
                }
                _myCouponListBlock (dataArray);
                break;
            }
            case 27:
            {
                User *user = [[User alloc] init];
                user.userTotal = [messageDict objectForKey:@"total"];
                user.userLeave = [messageDict objectForKey:@"leave"];
                _myPointINfoBlock (user);
                break;
            }
            case 28:
            {
                OrderInfo *orderInfo = [[OrderInfo alloc] init];
                NSDictionary *addDict  = [messageDict objectForKey:@"address"];
                orderInfo.oinfoId = [messageDict objectForKey:@"id"];
                if(addDict.count > 0)
                {
                    orderInfo.addId = [addDict objectForKey:@"id"];
                    orderInfo.addAddress = [addDict objectForKey:@"address"];
                    orderInfo.addContact = [addDict objectForKey:@"contact"];
                    orderInfo.addName = [addDict objectForKey:@"name"];
                }
                NSDictionary *serDict = [messageDict objectForKey:@"service"];
                if(serDict.count > 0)
                {
                    orderInfo.seType = [serDict objectForKey:@"type"];
                    orderInfo.seId = [serDict objectForKey:@"id"];
                    orderInfo.seName = [serDict objectForKey:@"name"];
                    orderInfo.seTitlePic = [serDict objectForKey:@"titlePic"];
                    orderInfo.sePrice_Type = [serDict objectForKey:@"price_type"];
                }

                orderInfo.oinfoTotal = [messageDict objectForKey:@"total"];
                _serverBookBlock (orderInfo);
                break;
            }
            case 29:    // 发送信息
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 发送信息
                    _sendMessageSuccess();
                }
                break;
            }
            case 30:    // 获取消息列表
            {
                for(NSDictionary *dict in messageArray)
                {
                    Message *message = [[Message alloc] init];
                    message.msgContent = [dict objectForKey:@"content"];
                    message.msgStyle = [dict objectForKey:@"style"];
                    message.msgId = [dict objectForKey:@"id"];
                    message.msgSend_Time = [dict objectForKey:@"send_time"];
                    NSDictionary *userDict = [dict objectForKey:@"from_user"];
                    if(userDict.count > 0)
                    {
                        message.userFace = [userDict objectForKey:@"face"];
                        message.userId = [userDict objectForKey:@"id"];
                        message.userName = [userDict objectForKey:@"name"];
                    }
                    [dataArray addObject:message];
                }
                self.status = @"1000";
                _talkListBlock (dataArray);
                break;
            }
            case 31:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Message *message = [[Message alloc] init];
                    if([[dict objectForKey:@"content"] isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *contentDict = [dict objectForKey:@"content"];
                        message.msgContent = [contentDict objectForKey:@"content"];
                        message.userFace = [contentDict objectForKey:@"pic"];
                        message.msgId = [contentDict objectForKey:@"id"];
                        message.userName = [contentDict objectForKey:@"title"];
                        [message.messageArray addObject:message];
                    }
                    else
                    {
                        message.msgId = [dict objectForKey:@"id"];
                        message.msgContent = [dict objectForKey:@"content"];
                    }
                    message.msgSend_Time = [dict objectForKey:@"send_time"];
                    message.senderId = [dict objectForKey:@"from_id"];
                    message.msgType = [dict objectForKeyedSubscript:@"type"];
                    [dataArray addObject:message];
                }
                _messageRepastBlock (dataArray);
                break;
            }
            case 33:    // 退出群组
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 退出群组成功
                    _quetGroupSuccess();
                }
                break;
            }
            case 32:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 创建群组成功
                    _groupId = [rootDict objectForKey:@"group_id"];
                    _groupMessageSuccess();
                }
                break;
            }
            case 34:
            {
                Message *message = [[Message alloc] init];
                message.msgId = [messageDict objectForKey:@"id"];
                message.msgType = [messageDict objectForKey:@"type"];
                message.msgModule_Id = [messageDict objectForKey:@"module_id"];
                message.msgPid = [messageDict objectForKey:@"pid"];
                message.msgFrom_Id = [messageDict objectForKey:@"from_id"];
                message.msgTo_Id = [messageDict objectForKey:@"to_id"];
                message.msgContent = [messageDict objectForKey:@"content"];
                message.msgSend_Time = [messageDict objectForKey:@"send_time"];
                _accpetMessage (message);
                break;
            }
            case 35:    // 通讯录
            {
                for(NSDictionary *dict in messageArray)
                {
                    User *user = [[User alloc] init];
                    user.userId = [dict objectForKey:@"id"];
                    user.userName = [dict objectForKey:@"name"];
                    user.userFace = [dict objectForKey:@"face"];
                    user.isChecked = NO;
                    [dataArray addObject:user];
                }
                _addressBookBlock (dataArray);
                break;
            }
            case 36:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 消息发送成功
                    _sendMessageSuccess();
                }
                break;
            }
            case 37:    // 获取群信息
            {
                Group *group = [[Group alloc] init];
                group.groupArray = [[NSMutableArray alloc] init];
                group.groupId = [messageDict objectForKey:@"id"];
                group.groupName = [messageDict objectForKey:@"name"];
                group.groupShield = [messageDict objectForKey:@"shield"];
                NSArray *array = [messageDict objectForKey:@"members"];
                for(NSDictionary *dict in array)
                {
                    User *user =[[User alloc] init];
                    user.userId = [dict objectForKey:@"id"];
                    user.userName = [dict objectForKey:@"name"];
                    user.userFace = [dict objectForKey:@"face"];
                    [group.groupArray addObject:user];
                }
                _selectGroupInfo(group);
                break;
            }
            case 38:    // 加载历史消息 (群聊)
            {
                Message *message = [[Message alloc] init];
                message.messageArray = [[NSMutableArray alloc] init];
                for(NSDictionary *dict in messageArray)
                {
                    Message *messages = [[Message alloc] init];
                    messages.msgId = [dict objectForKey:@"id"];
                    messages.msgContent = [dict objectForKey:@"content"];
                    messages.msgSend_Time = [dict objectForKey:@"send_time"];
                    messages.msgType = [dict objectForKey:@"type"];
                    NSDictionary *senderDict = [dict objectForKey:@"sender"];
                    messages.senderId = [senderDict objectForKey:@"id"];
                    messages.senderName = [senderDict objectForKey:@"name"];
                    messages.senderFace = [senderDict objectForKey:@"face"];
                    [dataArray addObject:messages];
                }
                _messageRepastBlock (dataArray);
                break;
            }
            case 39:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 发布评论成功
                    _sendMessageSuccess();
                }
                break;
            }
            case 40:
            {
                NeighobrInfo *neiInfo = [[NeighobrInfo alloc] init];
                neiInfo.neiInfoComments = [[NSMutableArray alloc] init];
                neiInfo.neiInfoUsers = [[NSMutableArray alloc] init];
                neiInfo.neiInfoPictures = [[NSMutableArray alloc] init];
                NSArray *commentArray = [messageDict objectForKey:@"comment"];
                for(NSDictionary *dict in commentArray)
                {
                    NeighobrInfo *nei = [[NeighobrInfo alloc] init];
                    nei.neiInfoContent = [dict objectForKey:@"content"];
                    nei.neiInfoId = [[dict objectForKey:@"id"] intValue];
                    nei.neiInfoSend_Time = [dict objectForKey:@"send_time"];
                    NSDictionary *dictUser = [dict objectForKey:@"user"];
                    User *user = [[User alloc] init];
                    user.userFace = [dictUser objectForKey:@"face"];
                    user.userId = [dictUser objectForKey:@"id"];
                    user.userName = [dictUser objectForKey:@"name"];
                    [neiInfo.neiInfoComments addObject:nei];
                    [neiInfo.neiInfoUsers addObject:user];
                }
                NSArray *pictures = [messageDict objectForKey:@"pictures"];
                for(NSString *pircture in pictures)
                {
                    [neiInfo.neiInfoPictures addObject:pircture];
                }
                neiInfo.neiInfoCommentNum = [messageDict objectForKey:@"commentNum"];
                neiInfo.neiInfoContent = [messageDict objectForKey:@"content"];
                neiInfo.neiInfoCurrent = [[messageDict objectForKey:@"current"] integerValue];
                neiInfo.neiInfoForwardNum = [messageDict objectForKey:@"forwardNum"];
                neiInfo.neiInfoId = [[messageDict objectForKey:@"id"] integerValue];
                neiInfo.neiInfoLookNum = [messageDict objectForKey:@"lookNum"];
                neiInfo.neiInfoSend_Time = [messageDict objectForKey:@"send_time"];
                neiInfo.neiInfoShareNum = [messageDict objectForKey:@"shareNum"];
                neiInfo.neiInfoTitlePic = [messageDict objectForKey:@"titlePic"];
                neiInfo.neiInfoTotal = [[messageDict objectForKey:@"total"] integerValue];
                neiInfo.neiInfoZanNum = [messageDict objectForKey:@"zanNum"];
                _neighborInfoBlock (neiInfo);
                break;
            }
            case 41:    // 提交优惠券订单
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    
                    Order *order = [[Order alloc] init];
                    order.orderCode = [messageDict objectForKey:@"code"];
                    order.orderMoney = [messageDict objectForKey:@"money"];
                    order.sign = [messageDict objectForKey:@"sign_data"];
                    _getCouponBlock (order);
                }
                break;
            }
            case 43:
            {
                for(NSString *str in messageArray)
                {
                    [dataArray addObject:str];
                }
                _myRoomList (dataArray);
                break;
            }
            case 44:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Property *pro = [[Property alloc] init];
                    pro.proEnd = [dict objectForKey:@"end"];
                    pro.proId = [dict objectForKey:@"id"];
                    pro.proMonth = [dict objectForKey:@"month"];
                    pro.proName = [dict objectForKey:@"name"];
                    pro.proPrice = [dict objectForKey:@"price"];
                    pro.proStart = [dict objectForKey:@"start"];
                    [dataArray addObject:pro];
                }
                _realPayBlock (dataArray);
                break;
            }
            case 45:
            {
                Order *order = [[Order alloc] init];
                order.orderCode = [messageDict objectForKey:@"code"];
                order.orderMoney = [messageDict objectForKey:@"money"];
                order.sign = [messageDict objectForKey:@"sign_data"];
                _realPaySubmitBlock (order);
                break;
            }
            case 46:
            {
                User *user = [[User alloc] init];
                user.userCommunity = [messageDict objectForKey:@"community"];
                user.userFace = [messageDict objectForKey:@"face"];
                user.userId = [messageDict objectForKey:@"id"];
                user.userNickName = [messageDict objectForKey:@"name"];
                user.userPhone = [messageDict objectForKey:@"phone"];
                user.userProfession = [messageDict objectForKey:@"profession"];
                user.userName = [messageDict objectForKey:@"realname"];
                user.userRoom = [messageDict objectForKey:@"room"];
                user.userSex = [messageDict objectForKey:@"sex"];
                _sayUserInfoBlock (user);
                break;
            }
            case 47:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Address *add = [[Address alloc] init];
                    add.addId = [dict objectForKey:@"id"];
                    add.addName = [dict objectForKey:@"name"];
                    add.addAddress = [dict objectForKey:@"address"];
                    add.addContact = [dict objectForKey:@"contact"];
                    add.addDefault = [dict objectForKey:@"default"];
                    [dataArray addObject:add];
                }
                _addressBlock (dataArray);
                break;
            }
            case 48:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    _addAddressBlock ();
                }
                break;
            }
            case 49:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Coupon *cou = [[Coupon alloc] init];
                    cou.couType = [dict objectForKey:@"type"];
                    cou.couName = [dict objectForKey:@"name"];
                    cou.couValue =[dict objectForKey:@"value"];
                    [dataArray addObject:cou];
                }
                _myCouponList (dataArray);
                break;
            }
            case 50:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    Order *order = [[Order alloc] init];
                    order.orderCode = [messageDict objectForKey:@"code"];
                    order.orderMoney = [messageDict objectForKey:@"money"];
                    order.sign = [messageDict objectForKey:@"sign_data"];
                    // 提交订单成功
                    _realPaySubmitBlock (order);
                }
                break;
            }
            case 51:    // 增加群组成员
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 增加群组成员成功
                    _sendMessageSuccess ();
                }
                break;
            }
            case 52:
            {
                User *user = [[User alloc] init];
                user.userCommunity = [messageDict objectForKey:@"community"];
                user.userFace = [messageDict objectForKey:@"face"];
                user.userId = [messageDict objectForKey:@"id"];
                user.userNickName = [messageDict objectForKey:@"name"];
                user.userPhone = [messageDict objectForKey:@"showPhone"];
                user.userProfession = [messageDict objectForKey:@"profession"];
                user.userName = [messageDict objectForKey:@"realname"];
                user.userRoom = [messageDict objectForKey:@"room"];
                user.userSex = [messageDict objectForKey:@"sex"];
                _getMyUserInfoBlock (user);
                break;
            }
            case 53:
            {
                ServerDetail *sd = [[ServerDetail alloc] init];
                sd.asdEvents = [[NSMutableArray alloc] init];
                // 地址
                NSDictionary *addressDict = [messageDict objectForKey:@"address"];
                if(addressDict.count > 0)
                {
                    sd.asdaddress = [addressDict objectForKey:@"address"];
                    sd.asdContact = [addressDict objectForKey:@"contact"];
                    sd.asdId = [addressDict objectForKey:@"id"];
                    sd.asdName = [addressDict objectForKey:@"name"];
                }
                
                //
                NSDictionary *rsdDict = [messageDict objectForKey:@"reservation"];
                if(rsdDict.count > 0)
                {
                    sd.rsdId = [rsdDict objectForKey:@"id"];
                    sd.rsdPhone = [rsdDict objectForKey:@"phone"];
                    sd.rsdName = [rsdDict objectForKey:@"name"];
                    sd.rsdRomm = [rsdDict objectForKey:@"room"];
                    sd.rsdDate_Time = [rsdDict objectForKey:@"date_time"];
                }
                
                // 服务
                NSDictionary *serviceDict = [messageDict objectForKey:@"service"];
                sd.ssdCoupon = [serviceDict objectForKey:@"coupon"];
                sd.ssdId = [serviceDict objectForKey:@"id"];
                sd.ssdIntegral = [serviceDict objectForKey:@"integral"];
                sd.ssdInvoice = [serviceDict objectForKey:@"invoice"];
                sd.ssdName = [serviceDict objectForKey:@"name"];
                sd.ssdPrice_Type = [serviceDict objectForKey:@"price_type"];
                sd.ssdReturnable = [serviceDict objectForKey:@"teturnable"];
                sd.ssdTitlePic = [serviceDict objectForKey:@"titlePic"];
                sd.ssdType = [serviceDict objectForKey:@"type"];
                
                //
                sd.sdOrder_Time = [messageDict objectForKey:@"order_time"];
                sd.sdCode = [messageDict objectForKey:@"code"];
                sd.sdCoupon_Num = [messageDict objectForKey:@"coupon_num"];
                sd.sdCoupon_off = [messageDict objectForKey:@"coupon_off"];
                sd.sdState = [messageDict objectForKey:@"state"];
                sd.sdTotal = [messageDict objectForKey:@"total"];
                sd.sdInvoice_t = [messageDict objectForKey:@"invoice_t"];
                sd.sdInvoice_s = [messageDict objectForKey:@"invoice_s"];
                
                // 服务的东西
                for(NSDictionary *dict in [messageDict objectForKey:@"events"])
                {
                    Server *server = [[Server alloc] init];
                    server.serName  = [dict objectForKey:@"name"];
                    server.serCount = [dict objectForKey:@"num"];
                    [sd.asdEvents addObject:server];
                }
                _orderServerDetailBlock (sd);
                break;
            }
            case 54:
            {
                for(NSDictionary *dict in messageArray)
                {
                    User *user = [[User alloc] init];
                    user.userId = [dict objectForKey:@"id"];
                    user.userName = [dict objectForKey:@"name"];
                    user.userFace = [dict objectForKey:@"face"];
                    [dataArray addObject:user];
                }
                _shieldListBlock (dataArray);
                break;
            }
            case 55:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 解除邻居说成功!
                    _sendMessageSuccess ();
                }
                break;
            }
            case 56:
            {
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                {
                    // 修改密码接口
                    _sendMessageSuccess ();
                    break;
                }
                break;
            }
            case 57:
            {
                NSString *money = [rootDict objectForKey:@"money"];
                _orderEditServer (money);
                break;
            }
            case 58:
            {
                // 转发成功
                if([[rootDict objectForKey:@"status"] isEqualToString:@"200"])
                    _sendMessageSuccess ();
                break;
            }
            case 59:
            {
                for(NSDictionary *dict in messageArray)
                {
                    Neighbor *nei = [[Neighbor alloc] init];
                    nei.neiPictureArray = [[NSMutableArray alloc] init];
                    nei.neiUserArray = [[NSMutableArray alloc] init];
                    nei.neiContent = [dict objectForKey:@"content"];
                    nei.neiForwardNum = [dict objectForKey:@"forwardNum"];
                    nei.neiId = [dict objectForKey:@"id"];
                    nei.neiSend_Time = [dict objectForKey:@"send_time"];
                    nei.neiShareNum = [dict objectForKey:@"shareNum"];
                    nei.neiTitlePic = [dict objectForKey:@"titlePic"];
                    nei.neiType = [dict objectForKey:@"zanNum"];
                    nei.neiZan = [dict objectForKey:@"zan"];    // 是否点过赞.
                    NSArray *pictureArray = [dict objectForKey:@"pictures"];
                    for(NSString *str in pictureArray)
                    {
                        [nei.neiPictureArray addObject:str];
                    }
                    NSDictionary *userDict = [dict objectForKey:@"user"];
                    User *user = [[User alloc] init];
                    user.userId = [userDict objectForKey:@"id"];
                    user.userName = [userDict objectForKey:@"name"];
                    user.userFace = [userDict objectForKey:@"face"];
                    [nei.neiUserArray addObject:user];
                    [dataArray addObject:nei];
                }
                _neighborListBlock (dataArray);
                 break;
            }
            case 60:
            {
                // 商户取消订单
                _sendMessageSuccess ();
                break;
            }
            case 61:
            {
                NSString *iamgeName = [NSString stringWithFormat:@"%@",messageDict];
                _uploadImageSuccess (iamgeName);
                break;
            }
        }
    }
    else if([[rootDict objectForKey:@"status"] isEqualToString:@"300"])
    {
        if(request.tag == 42)
        {
            // 活动参加成功
            _joinSuccessBlock ();
        }
        else if(request.tag == 55)
        {
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"黑名单没有用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if(request.tag == 1)
        {
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if([[rootDict objectForKey:@"status"] isEqualToString:@"400"])
    {
        self.status = @"400";
        NSString *str = [NSString stringWithFormat:@"%@",messageDict];
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 4;
        [alert show];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@",messageDict];
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


// 获取数据
- (NSMutableArray *)getDataWithKey:(NSString *)key
{
    return [_dataDict objectForKeyedSubscript:key];
}

@end
