//
//  orderSeRdDetailCell.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemRadio.h"
#import "ItemTitle.h"
#import "OrderRdData.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "orderSegementView.h"
#define ORDERSERDCELL @"ordersedddetailcell"
#define SECELLHIGHT 236;
@interface orderSeRdDetailCell : UITableViewCell <IEditItemListEvent,IEditItemRadioEvent>

@property (strong, nonatomic) IBOutlet UILabel *Titlelbl;
@property (strong, nonatomic) IBOutlet EditItemRadio *frSwitch;
@property (strong, nonatomic) IBOutlet orderSegementView *smSegView;
@property (strong, nonatomic) IBOutlet EditItemRadio *seSwitch;
@property (strong, nonatomic) IBOutlet orderSegementView *bgSegView;
@property (strong, nonatomic) IBOutlet UIView *Iteamtitle;
//-(void)initView;
-(void)initTitlte:(NSString *)title;

-(void)initView:(id<IEditItemRadioEvent>)delegate  indexpatch:(NSIndexPath *)indexpatch  segementdelegate:(id<AddOrDeletNum>)sedelegate iteam:(OrderRdData *)iteam;
-(void)change:(NSInteger)num isFrist:(BOOL)isFrist;
-(void)changestatus:(NSInteger)tag;
@end
