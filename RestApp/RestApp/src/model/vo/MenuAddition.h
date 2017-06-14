//
//  MenuAddition.h
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"
#import "INameItem.h"


@interface MenuAddition : Jastor<INameItem,INameValueItem>

@property (nonatomic,retain) NSString * menuId;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * kindMenuName;
@property (nonatomic,retain) NSString * kindMenuId;
@property (nonatomic,retain) NSString * entityId;
@property (nonatomic,retain) NSString * relationKindMenuId;
@property (nonatomic) double price;

@end
