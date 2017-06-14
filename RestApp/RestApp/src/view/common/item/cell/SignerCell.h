//
//  SignerCell.h
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "KindPayDetailOption.h"
#import "INameValueItem.h"

@interface SignerCell : UITableViewCell<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblType;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) KindPayDetailOption* obj;
@property (nonatomic) NSString* type;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(KindPayDetailOption*)objTemp type:(NSString*)type;
-(IBAction) btnDelClick:(id)sender;

@end
