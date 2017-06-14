//
//  ChainMenuFooterListView.m
//  RestApp
//
//  Created by zishu on 16/10/15.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "ChainMenuFooterListView.h"
#import "ObjectUtil.h"
#import "UIView+Sizes.h"
@implementation ChainMenuFooterListView
@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ChainMenuFooterListView" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    [self addSubview:self.view];
}

- (void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr withGoodsTitle:(NSString *) goodTitle withPackageTitle :(NSString *) packageTitle withFontSize:(CGFloat) fontSize
{
    self.btnAddMenu.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.btnAddSuitMenul.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.delegate=delegate;
    [self hideAllBtn];
    BOOL sortVisibal=NO;
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSString* btnName in arr) {
            if ([[btnName uppercaseString] isEqualToString:@"BATCH"]) {
                [self showBtn:self.btnBatch img:self.imgBatch title:NSLocalizedString(@"批量", nil) showStatus:YES];
            } else if ([[btnName uppercaseString] isEqualToString:@"ADDMENU"]) {
                [self showBtn:self.btnAddMenu img:self.imgAddMenu title:goodTitle showStatus:YES];
            } else if ([[btnName uppercaseString] isEqualToString:@"ADDSUITMENU"]) {
                [self showBtn:self.btnAddSuitMenul img:self.imgAddSuitMenu title:packageTitle showStatus:YES];
            } else if ([[btnName uppercaseString] isEqualToString:@"SORT"]) {
                [self showBtn:self.btnSort img:self.imgSort title:NSLocalizedString(@"排序", nil) showStatus:YES];
                sortVisibal=YES;
            }
        }
    }
}

-(void) hideAllBtn
{
    self.btnAddSuitMenul.hidden=YES;
    self.btnAddMenu.hidden=YES;
    self.btnSort.hidden=YES;
    self.btnBatch.hidden=YES;
    
    self.imgAddMenu.hidden=YES;
    self.imgAddSuitMenu.hidden=YES;
    self.imgSort.hidden=YES;
    self.imgBatch.hidden=YES;
}

-(void) showHelp:(BOOL)showFlag
{
    if (showFlag) {
        self.imgHelp.hidden = NO;
        self.btnHelp.hidden = NO;
    }
    else
    {
        self.imgHelp.hidden = YES;
        self.btnHelp.hidden = YES;
    }
}

-(void) showBtn:(UIButton*)btn img:(UIImageView*)img title:(NSString *)title showStatus:(BOOL)status
{
    [btn setTitle:title forState:UIControlStateNormal];
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction) onAddMenuClickEvent:(id)sender
{
    [self.delegate showAddEvent];
}

- (IBAction) onAddSuitMenuClickEvent:(id)sender
{
    [self.table setEditing:YES animated:YES];
    [self.delegate showAddSuitMenuEvent];
}
- (IBAction) onSortClickEvent:(id)sender
{
    [self.delegate showSortEvent];
}
- (IBAction) onHelpClickEvent:(id)sender
{
    [self.delegate showHelpEvent];
}

- (IBAction) onBatchClickEvent:(id)sender
{
    [self.delegate showBatchEvent];
}

@end
