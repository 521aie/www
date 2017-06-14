//
//  TDFWXNotificationModel.h
//  RestApp
//
//  Created by Octree on 18/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"
#import "NSDate+TDFMilliInterval.h"

//   推送目标
typedef NS_ENUM(NSInteger, TDFWXNotificationTargetType) {
    
    TDFWXNotificationTargetTypeAll,                 //   所有有粉丝
    TDFWXNotificationTargetTypeTagGroup,            //   标签分组
    TDFWXNotificationTargetTypeIntelligentGroup,    //   智能分组
};

typedef NS_ENUM(NSInteger, TDFWXNotificationContentType) {
    
    TDFWXNotificationContentTypeMemberCard,                 //   会员卡
    TDFWXNotificationContentTypeCoupon,                     //   优惠券
    TDFWXNotificationContentTypePromotion,                  //   促销活动
};

@interface TDFWXNotificationModel : TDFBaseModel

@property (copy, nonatomic) NSString *officialAccountName;
@property (copy, nonatomic) NSString *officialAccountId;
@property (assign, nonatomic) NSInteger fansNumber;             //   粉丝数量
@property (assign, nonatomic) TDFWXNotificationTargetType targetType;
@property (copy, nonatomic) NSString *groupId;                  //   分组 Id
@property (copy, nonatomic) NSString *groupName;                //   分组名称
@property (assign, nonatomic) NSInteger groupMemberNumber;      //   成员数量
@property (copy, nonatomic) NSString *tagId;                    //   标签 Id
@property (assign, nonatomic) NSInteger tagMemberNumber;        //   标签成员数量
@property (copy, nonatomic) NSString *tagName;                  //   标签 Name

@property (copy, nonatomic) NSString *plateId;                  //   品牌 Id
@property (copy, nonatomic) NSString *plateName;                //   品牌名称


@property (assign, nonatomic) TDFWXNotificationContentType contentType;
@property (copy, nonatomic) NSString *contentId;                //   推送内容（卡/券/促销） 的 id
@property (copy, nonatomic) NSString *contentName;              //   推送内容（卡/券/促销） 的 name

@property (copy, nonatomic) NSString *text;                     //   推送内容的文本信息

@property (assign, nonatomic) TDFMilliTimeInterval sendDate;    //   发送时间


@property (copy, nonatomic, readonly) NSString *targetName;
@property (assign, nonatomic, readonly) NSInteger targetMemberNumber;

@end

/**
 *  微信推送内容 Model
 */
@interface TDFWXContentModel : TDFBaseModel <INameItem>

@property (copy, nonatomic) NSString *name;

@end
