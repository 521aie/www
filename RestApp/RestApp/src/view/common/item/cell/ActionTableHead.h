//
//  ActionTableHead.h
//  RestApp
//
//  Created by zxh on 14-10-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "INameValueItem.h"

@interface ActionTableHead : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIView *panel;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) id<INameValueItem> obj;
@property (strong, nonatomic) NSString* event;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event;

@end
