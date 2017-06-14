//
//  TDFOfficialAccountMenuCell.h
//  TDFFakeOfficialAccount
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFOfficialAccountMenuPresenter : NSObject

@property (copy, nonatomic) NSString *title;
@property (nonatomic) BOOL showArrow;

@end

@interface TDFOfficialAccountMenuCell : UICollectionViewCell

- (CGSize)sizeThatFits:(CGSize)size withPresenter:(TDFOfficialAccountMenuPresenter *)presenter;

- (void)updateWithPresenter:(TDFOfficialAccountMenuPresenter *)presenter NS_REQUIRES_SUPER;

@end
