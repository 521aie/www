//
//  orderThDetailCell.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#define ORDERTHDETAILCELL @"orderThDetailCell"
#define THCELLHEIGHT 188
@interface orderThDetailCell : UITableViewCell <IEditItemListEvent ,IEditItemRadioEvent>

@property (strong, nonatomic) IBOutlet UILabel *Titlelbl;
@property (strong, nonatomic) IBOutlet EditItemRadio *frSwitch;
@property (strong, nonatomic) IBOutlet EditItemList *smSegView;
@property (strong, nonatomic) IBOutlet EditItemRadio *seSwitch;
-(void)initView;
@end
