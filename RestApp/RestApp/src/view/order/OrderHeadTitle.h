//
//  OrderHeadTitle.h
//  RestApp
//
//  Created by apple on 16/5/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBase.h"
#import "EditItemBase.h"
#import "IItemTitleEvent.h"

@protocol TitleClickButton <NSObject>

-(void)click:(BOOL)slelct;

@end
@interface OrderHeadTitle : EditItemBase
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *lblname;
@property (strong, nonatomic) IBOutlet UILabel *detailname;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UIImageView *img;

- (IBAction)btnClick:(UIButton *)sender;
@property (nonatomic ,assign) id<TitleClickButton>delegate;
-(void)initdelegate:(id<TitleClickButton>)delgate;
- (void) initLabel:(NSString *)label withVal:(NSString*)data;
- (void) changeLabel:(NSString*)label withVal:(NSString*)data;
@end
