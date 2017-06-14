//
//  orderHideMuluSelect.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderMuluSelect.h"
#import "CusButton.h"
#import "EditItemBase.h"


@interface orderHideMuluSelect : EditItemBase <OrderMuluteDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet CusButton *FrButton;
@property (weak, nonatomic) IBOutlet CusButton *SeButton;
@property (weak, nonatomic) IBOutlet CusButton *ThButton;
@property (weak, nonatomic) IBOutlet CusButton *FoButton;
@property (weak, nonatomic) IBOutlet CusButton *FvButton;
@property (weak, nonatomic) IBOutlet CusButton *SixButton;
@property (weak, nonatomic) IBOutlet CusButton *SevenButton;
@property (weak, nonatomic) IBOutlet CusButton *EiButton;


@property (assign,nonatomic) id <changeIteamImg> delegate;

- (void)initImplicit:(NSInteger)tag;
-(void)restView:(BOOL)ishide;
-(void)initDelegate:(id <changeIteamImg >)delegate;
-(void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag;
-(void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color title:(NSString *)title;
-(void)createViewWithCount:(NSInteger)count;
@end
