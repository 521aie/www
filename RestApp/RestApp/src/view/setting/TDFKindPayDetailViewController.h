//
//  TDFKindPayDetailViewController.h
//  RestApp
//
//  Created by hulatang on 16/6/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
typedef NS_ENUM(NSUInteger, TDFKindPayType){
    TDFKindPayTypeAdd = 1,
    TDFKindPayTypeEdit
};

@class KindPay,SettingModule;
@interface TDFKindPayDetailViewController : TDFRootViewController<NavigationToJump>

@property (nonatomic,assign)BOOL IsAdd;
@property (nonatomic,assign)BOOL thridStatus;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic, assign)id <NavigationToJump>delegate;
- (instancetype)initWithParent:(SettingModule *)parent;
- (void)loadViewWith:(KindPay *)kindPay With:(TDFKindPayType)payType;

@end
