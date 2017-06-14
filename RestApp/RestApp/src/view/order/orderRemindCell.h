//
//  orderRemindCell.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORDERREMAINCELL @"orderRemindCell"
#define REMAINCELLHEIGHT 64

@protocol SizetofitKeyboard <NSObject>

-(void)ScrollViewTheViewWithPatch:(NSIndexPath *)patch title:(NSString *)title;
-(void)popTanchView;
@end
@interface orderRemindCell : UITableViewCell <UITextFieldDelegate>
{
    NSIndexPath *patch;
}
@property (strong, nonatomic) IBOutlet UIView *headLine;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UITextField *textFild;
@property (assign, nonatomic) id <SizetofitKeyboard> delegate;
-(void)initHideHead:(BOOL)hide;
-(void)initTitlelbl:(NSString *)title;
-(void)initTextfild:(NSString *)title;
-(void)initDelegate:(id <SizetofitKeyboard>)delegate path:(NSIndexPath*)Indexpatch;

@end
