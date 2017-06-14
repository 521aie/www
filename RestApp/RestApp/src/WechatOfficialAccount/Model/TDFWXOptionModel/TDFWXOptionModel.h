//
//  TDFWXOptionModel.h
//  RestApp
//
//  Created by Octree on 15/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"
#import "INameItem.h"

///   有很多配置选项，属性只有 id 和 name

@interface TDFWXOptionModel : TDFBaseModel<INameItem>

@property (copy, nonatomic) NSString *name;

@end
