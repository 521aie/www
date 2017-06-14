//
//  MultiCheckDetailCell.h
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@interface MultiCheckMasterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCheck;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnCheck;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) id<INameValueItem> obj;
@property NSString* event;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)obj event:(NSString*)event;
-(IBAction) btnEditClick:(id)sender;

@end
