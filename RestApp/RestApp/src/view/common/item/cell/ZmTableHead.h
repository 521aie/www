//
//  ZmTableHead.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "INameValueItem.h"

@interface ZmTableHead : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblKind;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIView *panel;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) id<INameValueItem> obj;
@property (strong, nonatomic) NSString* eventType;
-(void)loadData:(NSString*)kindName obj:(id<INameValueItem>)obj delegate:(id<ISampleListEvent>)delegate event:(NSString*)event;

-(IBAction)btnDelClick:(id)sender;

@end
