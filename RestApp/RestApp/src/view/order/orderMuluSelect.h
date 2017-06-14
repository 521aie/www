//
//  orderMuluSelect.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusButton.h"
#import "EditItemBase.h"

@class orderMuluSelect;
@protocol changeIteamImg  <NSObject>

-(void)changeIteam:(id)obj Button:(CusButton *)button isHide:(BOOL)hide;

@end

@interface orderMuluSelect : EditItemBase <OrderMuluteDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
//@property (strong, nonatomic) IBOutlet UIView *HeadVIew;
//@property (strong, nonatomic) IBOutlet UIView *footView;
//
//@property (weak, nonatomic) IBOutlet CusButton *FrButton;
//@property (weak, nonatomic) IBOutlet CusButton *SeButton;
//@property (weak, nonatomic) IBOutlet CusButton *ThButton;
//@property (weak, nonatomic) IBOutlet CusButton *FoButton;
//@property (weak, nonatomic) IBOutlet CusButton *FvButton;
//@property (weak, nonatomic) IBOutlet CusButton *SixButton;
//@property (weak, nonatomic) IBOutlet CusButton *SevenButton;
//@property (weak, nonatomic) IBOutlet CusButton *EiButton;
@property (strong, nonatomic) IBOutlet UILabel *detaiLbl;
@property (strong, nonatomic) IBOutlet UIView *headLine;

@property (nonatomic ,assign)id <changeIteamImg>delegate;
-(void)buildTheDelegate:(id <changeIteamImg >)delegate title:(NSString *)title;
//- (void)initImplicit:(NSInteger)tag;
- (void)hideHeadTitle:(BOOL)hide;

- (void)createViewWithArry:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag hideColor:(UIColor *)hideColor;
@end
