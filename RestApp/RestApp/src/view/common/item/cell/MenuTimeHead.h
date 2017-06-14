//
//  MenuTimeHead.h
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "MenuTime.h"

@interface MenuTimeHead : UIView


@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIView *panel;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) MenuTime* obj;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(MenuTime*)objTemp;
-(IBAction) btnEditClick:(id)sender;

@end
