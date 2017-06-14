//
//  TDFSwitchTool.h
//  RestApp
//
//  Created by 黄河 on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopStatusVo;
@interface TDFSwitchTool : NSObject
///主页弹窗中的重要通知是否显示
@property (nonatomic, assign)int isHangzhouShop;

///所有code对应的functionVO 体检项目需要
@property (nonatomic, strong)NSDictionary *codeWithFunctionVoDic;

@property (nonatomic, strong)ShopStatusVo *shopInfo;

@property (nonatomic, strong)UINavigationController *rootViewController;



+ (instancetype)switchTool;

- (void)pushViewControllerWithCode:(NSString *)actionCode
                         andObject:(NSArray *)codeArray
                         andObject:(NSArray *)childFunctionArr
                withViewController:(UIViewController *)viewController;
@end
