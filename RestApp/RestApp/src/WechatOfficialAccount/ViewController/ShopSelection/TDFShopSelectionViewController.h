//
//  TDFShopSelectionViewController.h
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TDFAsync/TDFAsync.h>

/**
 *  特约商户 - 商店状态
 */
typedef NS_ENUM(NSInteger, TDFShopStatus) {
    
    TDFShopStatusNotPurchase        =       0,      //  未购买
    TDFShopStatusPurchased          =       1,      //  已购买
    TDFShopStatusSelected           =       2,      //  已被选择
    TDFShopStatusPermissionDeny     =       3,      //  没有权限
};

@class ShopVO;
@interface TDFShopSelectionViewController : UIViewController

@property (copy, nonatomic) NSString *commitTitle;

/**
 *  点击保存
 */
@property (strong, nonatomic) void(^confirmBlock)(NSArray <ShopVO *>* objs);

/**
 *  加载数据
 */
@property (strong, nonatomic) TDFAsync *loadAsync;

@end
