//
//  TDFWXGroupModel.h
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"
#import "INameItem.h"

/**
 *  微信公众号智能分组/Tag 分组
 */
@interface TDFWXGroupModel : TDFBaseModel <INameItem>

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger memberCount;
@property (assign, nonatomic) BOOL canPickPlate;
@end
