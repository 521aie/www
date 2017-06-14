//
//  Entity.h
//  RestApp
//
//  Created by zxh on 14-3-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseEntity.h"

@interface Entity : BaseEntity
//1:钻木,2:连锁,3:店铺,4:会员卡,5:品牌,6:机构
//industry==0&&entityTypeId=="2"表示连锁
@property(nonatomic, assign) NSInteger industry;
@end
