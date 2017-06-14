//
//  TDFOfficialAccountModel.h
//  RestApp
//
//  Created by Octree on 9/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"
#import "INameItem.h"
#import "NSDate+TDFMilliInterval.h"


//typedef NS_ENUM(NSInteger, TDFOfficialAccountType) {
//
//    TDFOfficialAccountTypeService           =       0,                  //   服务号
//    TDFOfficialAccountTypeSubscription      =       1,                  //   订阅号
//} ;

@interface TDFOfficialAccountPermissionModel: TDFBaseModel

@property (copy, nonatomic) NSString *name;
@property (nonatomic) NSInteger status;   // 0 deny, 1 allow

@end

/**
 *  微信公众号
 */
@interface TDFOfficialAccountModel : TDFBaseModel <INameItem, NSCopying>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;             //  订阅号/服务号
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *hasPermission;
@property (copy, nonatomic) NSArray *wxPermissions;
@property (nonatomic) NSInteger storeNum;               //   绑定店铺的数量


@end
