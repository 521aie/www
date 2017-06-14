//
//  TDFSubShopHeader.h
//  RestApp
//
//  Created by Cloud on 2017/4/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFSubShopHeader : UIView

@property (nonatomic ,copy) void (^back)();

- (instancetype)initWithController:(UIViewController *)vc
                        andDateStr:(NSString *)date
                        andTypeStr:(NSString *)type
                       andCallBack:(void(^)(NSMutableDictionary *dic))dic;

@end
