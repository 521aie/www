//
//  TDFBusinessSpellModel.h
//  RestApp
//
//  Created by happyo on 2016/11/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"

static NSString *kBusinessSpellAllDay = @"全天";

@interface TDFBusinessSpellModel : NSObject <INameItem>

@property (nonatomic, strong) NSString *bTime;

@property (nonatomic, strong) NSString *eTime;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isAll;

@end
