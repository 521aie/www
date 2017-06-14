//
//  TDFBarcodeScanResultModel.h
//  RestApp
//
//  Created by doubanjiang on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFBarcodeScanResultModel : NSObject

@property (nonatomic, copy) NSString *codeId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

@end
