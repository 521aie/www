//
//  orderFrDetailCell.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetaiTitle.h"
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#define ORDERFRDECELL @"orderFrDetailCell"
#define RFRCELLGEIHGT 236
@interface orderFrDetailCell : UITableViewCell <IEditItemRadioEvent,IEditItemListEvent>

@property (strong, nonatomic) IBOutlet ItemDetaiTitle *headTitle;
@property (strong, nonatomic) IBOutlet UILabel *Titlelbl;
@property (strong, nonatomic) IBOutlet EditItemRadio *frSwitch;
@property (strong, nonatomic) IBOutlet EditItemList *smSegView;
@property (strong, nonatomic) IBOutlet EditItemRadio *seSwitch;
-(void)loadAllTitle:(NSString *)title rightTitle:(NSString *)title1 delegate:(id<IteamDetaiTitleEvent>)delegate;
-(void)initView;
-(void)initTitlte:(NSString *)title;
@end
