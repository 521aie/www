//
//  FuctionPopView.h
//  RestApp
//
//  Created by iOS香肠 on 15/12/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMenuDetaiAction.h"
#import "RestConstants.h"
#import "ActionConstants.h"
#import "Platform.h"

@interface FuctionPopView : UIView
@property (strong,nonatomic)IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIView *popview;
@property (weak, nonatomic) IBOutlet UIView *faxtionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contentlbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgTitlePic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *showlbl;
@property (weak, nonatomic) IBOutlet UILabel *subjectlbl;
@property (weak, nonatomic) IBOutlet UIView *blankview;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgArr;
@property (weak, nonatomic) IBOutlet UIImageView *lock;

- (IBAction)selectDelete:(id)sender;
- (void)loadDatawithMenuAction:(UIMenuDetaiAction *)menuaction section:(NSInteger)section;
- (CGFloat)totalheightwithdata:(UIMenuDetaiAction *)menuaction;



@end

