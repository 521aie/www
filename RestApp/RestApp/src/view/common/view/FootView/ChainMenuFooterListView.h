//
//  ChainMenuFooterListView.h
//  RestApp
//
//  Created by zishu on 16/10/15.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
@interface ChainMenuFooterListView : UIView
{
    UIView *view;
}

@property (strong, nonatomic) IBOutlet UIImageView *imgHelp;
@property (strong, nonatomic) IBOutlet UIButton *btnHelp;

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIImageView *imgBatch;
@property (nonatomic, strong) IBOutlet UIButton *btnBatch;

@property (nonatomic, strong) IBOutlet UIImageView *imgSort;
@property (nonatomic, strong) IBOutlet UIButton *btnSort;

@property (nonatomic, strong) IBOutlet UIImageView *imgAddMenu;
@property (nonatomic, strong) IBOutlet UIButton *btnAddMenu;

@property (nonatomic, strong) IBOutlet UIImageView *imgAddSuitMenu;
@property (nonatomic, strong) IBOutlet UIButton *btnAddSuitMenul;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, copy) NSString *goodTitle;
@property (nonatomic, copy) NSString *packageTitle;

@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr  withGoodsTitle:(NSString *) goodTitle withPackageTitle :(NSString *) packageTitle withFontSize:(CGFloat) fontSize;

-(void) showHelp:(BOOL)showFlag;

- (IBAction) onBatchClickEvent:(id)sender;
- (IBAction) onAddMenuClickEvent:(id)sender;
- (IBAction) onAddSuitMenuClickEvent:(id)sender;
- (IBAction) onSortClickEvent:(id)sender;
- (IBAction) onHelpClickEvent:(id)sender;
@end
