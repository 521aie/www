//
//  FuctionViewCell.h
//  RestApp
//
//  Created by iOS香肠 on 15/12/17.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMenuDetaiAction.h"
#define MAIN_MENU_ITEM_HEIGHT 92
#define FUCTIONVIEWCELL @"FuctionViewCell"

@protocol FuctionViewCellDelegate <NSObject>
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;
@end
@interface FuctionViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *imgMenu;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UIImageView *imgLock;
@property (nonatomic, strong) IBOutlet UIImageView *img_check;
@property (weak, nonatomic) IBOutlet UIImageView *img_uncheck;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapopo;
@property (weak, nonatomic) IBOutlet UIImageView *imggray;

@property (nonatomic ,assign)id<FuctionViewCellDelegate>delegate;

- (IBAction)ClickpopVIew:(id)sender;

- (IBAction)Clickselect:(id)sender;
- (void)loadRadius;
- (void)fullModelId:(UIMenuDetaiAction *)menuAction dataArry:(NSArray*)codeArr With:(NSInteger)tag;
- (void)loadData:(UIMenuDetaiAction *)menuAction;
@end
