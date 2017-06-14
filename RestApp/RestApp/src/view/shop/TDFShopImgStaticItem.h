//
//  TDFShopImgStaticItem.h
//  RestApp
//
//  Created by doubanjiang on 2017/4/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"

@interface TDFShopImgStaticItem : DHTTableViewItem
    
@property (nonatomic, copy) void (^commitBlock)();

@property (nonatomic, assign) TDFEditStyle editStyle;

@property (nonatomic ,assign) BOOL isWaiting;

@end
