//
//  TDFForwardGroup.h
//  RestApp
//
//  Created by Cloud on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFForwardCells.h"

@interface TDFForwardGroup : NSObject

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *pageCode;

@property (nonatomic ,strong) NSMutableArray<TDFForwardCells *> *forwardCells;

@end
