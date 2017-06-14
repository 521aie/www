//
//  TDFOAMenuModel.h
//  RestApp
//
//  Created by Octree on 6/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"
#import "TDFBaseModel.h"
typedef NS_ENUM(NSInteger, TDFOAMenuType) {
    TDFOAMenuTypeNormal     =   1,          //  有子 Menu 的 Menu
    TDFOAMenuTypeURL        =   2,          //  URL 类型的 Menu
    TDFOAMenuTypeMessage    =   3,          //  自动回复消息类型的 Menu
};

typedef NS_ENUM(NSInteger, TDFOAMenuURLType) {

    TDFOAMenuURLTypeCustom      =       0,
    TDFOAMenuURLTypeMember      =       5,
};

typedef NS_OPTIONS(NSInteger, TDFOAMenuURLMenuType) {
    
    TDFOAMenuURLMenuTypeIgnoreShop       =       0,          //    不需要门店
    TDFOAMenuURLMenuTypeRequiredShop     =       1,          //    需要选择门店  1
    TDFOAMenuURLMenuTypeRequiredScope    =       2,          //    需要适用范围 10
};


typedef NS_ENUM(NSInteger, TDFOAMenuURLScopeType) {

    TDFOAMenuURLScopeTypePlate          =           0,      //   按品牌
    TDFOAMenuURLScopeTypeChain          =           1,      //   按连锁
};

@interface TDFOAMenuMessageModel : NSObject<INameItem>

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *demoPic;
@property (copy, nonatomic, readonly) NSURL *demoImageURL;

@end

/**
 *  微信公众号 URL
 */

@interface TDFOAMenuURLModel : TDFBaseModel<INameItem, NSCopying>

@property (copy, nonatomic) NSString *demoPic;
@property (copy, nonatomic, readonly) NSURL *demoImageURL;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *urlName;
@property (nonatomic) TDFOAMenuURLMenuType menuType;
@property (nonatomic) TDFOAMenuURLType urlType;

@end

@interface TDFOAMenuModel : TDFBaseModel <NSCopying>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) TDFOAMenuURLModel *urlDetail;
@property (copy, nonatomic) NSString *shopId;
@property (copy, nonatomic) NSString *shopName;
@property (nonatomic) TDFOAMenuURLScopeType scopeType;
@property (copy, nonatomic) NSArray <TDFOAMenuModel *> *subMenus;
@property (strong, nonatomic) TDFOAMenuMessageModel *messageDetail;

@property (copy, nonatomic) NSString *plateId;
@property (copy, nonatomic) NSString *plateName;

@property (nonatomic) TDFOAMenuType type;
@end
