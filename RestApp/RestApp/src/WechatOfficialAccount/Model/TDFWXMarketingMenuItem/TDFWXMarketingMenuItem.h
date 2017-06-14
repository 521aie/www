//
//  TDFWXMarketingMenuItem.h
//  RestApp
//
//  Created by Octree on 11/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TDFWXMarketingMenuItemType) {
    
    TDFWXMarketingMenuItemTypeSpecialTrader     =       0,      //      特约商户
    TDFWXMarketingMenuItemTypeRefund            =       1,      //      退款
    TDFWXMarketingMenuItemTypeAutoFollow        =       2,      //      自动关注
    TDFWXMarketingMenuItemTypeOAAuth            =       3,      //      授权
    TDFWXMarketingMenuItemTypeOAMenu            =       4,      //      自定义菜单
    TDFWXMarketingMenuItemTypeOANotification    =       5,      //      消息推送
    TDFWXMarketingMenuItemTypeOAQRCode          =       6,      //      二维码
    TDFWXMarketingMenuItemTypeOAMemberCard      =       7,      //      会员卡同步
    TDFWXMarketingMenuItemTypeOACoupon          =       8,      //      优惠券同步
    TDFWXMarketingMenuItemTypeOAFansAnalyze     =       9,      //      粉丝分析
    TDFWXMarketingMenuItemTypeTraderManager     =       10,     //      特约商户功能列表
};

typedef NS_OPTIONS(NSInteger, TDFWXMarketingMenuItemMode) {
    
    TDFWXMarketingMenuItemModeNormal                            =       0,
    TDFWXMarketingMenuItemModeHiddenWhenTraderManagedByChain    =   1 << 0,
    TDFWXMarketingMenuItemModeHiddenWhenOAManagedByChain        =   1 << 1,
};

@interface TDFWXMarketingMenuItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *badge;
@property (copy, nonatomic) NSString *actionCode;
@property (copy, nonatomic) UIColor *badgeColor;
@property (nonatomic, readonly) BOOL badgeHidden;
@property (nonatomic, assign) BOOL isBaseVersion;
@property (strong, nonatomic) UIImage *icon;
@property (nonatomic) BOOL hidden;
//   是否要显示
@property (nonatomic) BOOL permitted;                   //   有没有权限

@property (nonatomic) TDFWXMarketingMenuItemMode mode;
@property (nonatomic) TDFWXMarketingMenuItemType type;


- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail badge:(NSString *)badge icon:(UIImage *)icon permitted:(BOOL)permitted;
+ (instancetype)itemWithTitle:(NSString *)title detail:(NSString *)detail badge:(NSString *)badge icon:(UIImage *)icon permitted:(BOOL)permitted;

@end
