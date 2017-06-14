//
//  TDFSynchronizeCardInfoModel.h
//  RestApp
//
//  Created by 黄河 on 2017/3/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"
@interface TDFSynchronizeCardInfoModel : NSObject<NSCopying>

@property (nonatomic, strong)NSString *cardId;

@property (nonatomic, strong)NSString *cardName;
@end
