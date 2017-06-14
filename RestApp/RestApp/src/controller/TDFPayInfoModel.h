//
//  TDFPayInfoModel.h
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFPayInfoModel : NSObject

@property (nonatomic, strong) NSString *kindPayId;

@property (nonatomic, strong) NSArray *kindPayIds; // 关联的ids

@property (nonatomic, strong) NSString *kindPayName;

@property (nonatomic, assign) double money;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, assign) BOOL isAll;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
