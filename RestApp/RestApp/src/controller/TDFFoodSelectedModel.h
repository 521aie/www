//
//  TDFFoodSelectedModel.h
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFFoodSelectedModel : NSObject

@property (nonatomic, strong) NSString *menuId;

@property (nonatomic, strong) NSString *menuName;

@property (nonatomic, strong) NSString *menuCode;

@property (nonatomic, strong) NSString *menuSpell;

@property (nonatomic, assign) double menuPrice;

@property (nonatomic, assign) BOOL isSelected;

@end
