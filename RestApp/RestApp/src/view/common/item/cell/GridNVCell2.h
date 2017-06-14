//
//  GridNVCell2.h
//  RestApp
//
//  Created by zxh on 14-8-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "INameValueItem.h"

@interface GridNVCell2 : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UIImageView *imgDel;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) id<INameValueItem> obj;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* event;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp title:(NSString*)title event:(NSString*)event;

-(IBAction) btnDelClick:(id)sender;

@end
