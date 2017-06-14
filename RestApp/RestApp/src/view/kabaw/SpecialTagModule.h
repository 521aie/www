//
//  SpecialTagModule.h
//  RestApp
//
//  Created by Shaojianqing on 15/3/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpecialTagListView, SpecialTagEditView,orderDetailsView;
@interface SpecialTagModule : UIViewController

@property (nonatomic, strong) SpecialTagListView* specialTagListView;
@property (nonatomic, strong) SpecialTagEditView* specialTagEditView;
@property (nonatomic, strong) orderDetailsView * orderDetailsView;

-(void) showView:(NSInteger) viewTag;

@end
