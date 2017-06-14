//
//  TDFOfficialAccountLayout.m
//  TDFFakeOfficialAccount
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFOfficialAccountLayout.h"

@interface TDFOfficialAccountLayout ()

@property (strong, nonatomic) NSMutableDictionary *layoutDict;

@end

@implementation TDFOfficialAccountLayout

- (instancetype)init {

    if (self = [super init]) {
        
        _sectionPadding = 5;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.layoutDict = [NSMutableDictionary dictionary];
    
    NSUInteger count = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    NSAssert(count <= 3, NSLocalizedString(@"最多支持 3 个 section", nil));
    for (NSUInteger section = 0; section < count; section++) {
        
        [self calculateAttributesForSection:section];
    }
}


- (void)calculateAttributesForSection:(NSUInteger)section {

    CGFloat parentHeight = self.collectionView.frame.size.height;
    CGFloat sectionWidth = self.collectionView.frame.size.width / 3;
    CGFloat itemX = sectionWidth * section + self.sectionPadding;
    CGFloat itemWidth = self.itemWidth;
    
    id<TDFOfficialAccountLayoutDelegate> delegete = (id<TDFOfficialAccountLayoutDelegate>)self.collectionView.delegate;
    NSUInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    
    CGFloat totalHeight = 0;
    NSMutableArray *tempAttrs = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger item = 0; item < itemCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        CGFloat height = [delegete collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(itemX, totalHeight, itemWidth, height);
        totalHeight += height;
        self.layoutDict[indexPath] = attr;
        [tempAttrs addObject:attr];
    }
    
    CGFloat offset = parentHeight - totalHeight;
    for (UICollectionViewLayoutAttributes *attr in tempAttrs) {
        
        CGRect frame = attr.frame;
        frame.origin.y += offset;
        attr.frame = frame;
    }
}


- (CGSize)collectionViewContentSize {

    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    return [self.layoutDict objectForKey:indexPath];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *array = [NSMutableArray array];
    [self.layoutDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *key, UICollectionViewLayoutAttributes * obj, BOOL * _Nonnull stop) {
       
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (CGFloat)itemWidth {

    return self.collectionView.frame.size.width / 3 - self.sectionPadding * 2;
}

@end
