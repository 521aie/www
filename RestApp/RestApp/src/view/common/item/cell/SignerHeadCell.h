//
//  SignerHeadCell.h
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "KindPay.h"

@interface SignerHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIView *panel;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) KindPay* obj;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(KindPay*)objTemp;

-(IBAction) btnEditClick:(id)sender;

@end
