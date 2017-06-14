//
//  MenuStatisticsVo.h
//  RestApp
//
//  Created by xueyu on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuStatisticsVo : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *num_id;
@property (nonatomic,copy) NSString *entityId;
@property (nonatomic,copy) NSString *menuId;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) long createTime;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,assign) BOOL isSelf;
@property (nonatomic,assign) BOOL isAutomatic;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
