//
//  orderRdDetailCell.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemRadio.h"
#import "ItemDetaiTitle.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "orderSegementView.h"
#import "OrderRdData.h"
#define ODERERRDCELL @"orderrddetailcell"
#define CELLHIGHT 284
@interface orderRdDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *Titlelbl;
@property (strong, nonatomic) IBOutlet EditItemRadio *frSwitch;
@property (strong, nonatomic) IBOutlet orderSegementView *smSegView;
@property (strong, nonatomic) IBOutlet EditItemRadio *seSwitch;
@property (strong, nonatomic) IBOutlet orderSegementView *bgSegView;
@property (strong, nonatomic) IBOutlet ItemDetaiTitle *headTitle;
@property (strong, nonatomic) IBOutlet UIView *Iteamtitle;
@property (assign, nonatomic) BOOL isTitle;

-(void)initView:(id<IEditItemRadioEvent>)delegate indexpatch:(NSIndexPath *)indexpatch segementdelegate:(id<AddOrDeletNum>)sedelegate iteam:(OrderRdData *)iteam;
-(void)initTitlte:(NSString *)title;
-(void)loadLeftTitle:(NSString *)title;
-(void)loadAllTitle:(NSString *)title rightTitle:(NSString *)title1 delegate:(id<IteamDetaiTitleEvent>)delegate ;
-(void)change:(NSInteger)num isFrist:(BOOL)isFrist;
-(void)changestatus:(NSInteger)tag;
@end
