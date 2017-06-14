//
//  TimeArrangeCell.h
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "INameValueItem.h"

@interface TimeArrangeCell : UITableViewCell<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblVal;
@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) id<INameValueItem> obj;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp;
-(IBAction) btnDelClick:(id)sender;

@end
