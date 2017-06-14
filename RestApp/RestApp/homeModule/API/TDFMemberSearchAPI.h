//
//  TDFMemberSearchAPI.h
//  RestApp
//
//  Created by happyo on 2017/4/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFAPIKit/TDFAPIKit.h>

@interface TDFMemberSearchAPI : TDFBaseAPI

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) NSString *isMobile;

@end
