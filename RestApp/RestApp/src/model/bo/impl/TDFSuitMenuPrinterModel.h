//
//  TDFSuitMenuPrinterModel.h
//  RestApp
//
//  Created by 黄河 on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"
@interface TDFSuitMenuPrinterModel : NSObject<INameItem,NSCopying>
@property (nonatomic, strong)NSString *menuID;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)BOOL needOneMealOneCut;
@property (nonatomic, assign)BOOL isChain;
@end
